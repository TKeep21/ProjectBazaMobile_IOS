import CryptoKit
import Foundation

actor NewsImageCacheStore {
    private let fileManager: FileManager
    private let directoryURL: URL
    private let session: URLSession

    init(fileManager: FileManager = .default, session: URLSession = .shared) {
        self.fileManager = fileManager
        self.session = session
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        self.directoryURL = (base ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent("news_images", isDirectory: true)
    }

    func loadImageData(url: URL) async throws -> Data? {
        try ensureDirectory()
        try cleanupIfNeeded()
        let path = fileURL(for: url)
        guard fileManager.fileExists(atPath: path.path) else {
            return nil
        }
        let values = try path.resourceValues(forKeys: [.contentModificationDateKey])
        let modifiedAt = values.contentModificationDate ?? Date.distantPast
        let age = Date().timeIntervalSince(modifiedAt)
        if age > NewsCachePolicy.imageMaxLifetime {
            try fileManager.removeItem(at: path)
            return nil
        }
        return try Data(contentsOf: path)
    }

    func saveImageData(_ data: Data, for url: URL) async throws {
        try ensureDirectory()
        try data.write(to: fileURL(for: url), options: .atomic)
        try cleanupIfNeeded()
    }

    func fetchImageData(url: URL) async throws -> Data {
        if let cached = try await loadImageData(url: url) {
            return cached
        }
        let (data, response) = try await session.data(from: url)
        if let http = response as? HTTPURLResponse, !(200 ... 299).contains(http.statusCode) {
            throw NewsServiceError.badStatusCode(http.statusCode)
        }
        try await saveImageData(data, for: url)
        return data
    }

    private func ensureDirectory() throws {
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
    }

    private func fileURL(for url: URL) -> URL {
        let key = Insecure.MD5.hash(data: Data(url.absoluteString.utf8))
        let name = key.map { String(format: "%02x", $0) }.joined()
        return directoryURL.appendingPathComponent(name + ".img", isDirectory: false)
    }

    private func cleanupIfNeeded() throws {
        let urls = try fileManager.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )
        if urls.count <= NewsCachePolicy.maxImageFileCount {
            return
        }
        let sorted = try urls.sorted { lhs, rhs in
            let ld = try lhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate ?? Date.distantPast
            let rd = try rhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate ?? Date.distantPast
            return ld < rd
        }
        let toDelete = sorted.prefix(urls.count - NewsCachePolicy.maxImageFileCount)
        for url in toDelete {
            try fileManager.removeItem(at: url)
        }
    }
}
