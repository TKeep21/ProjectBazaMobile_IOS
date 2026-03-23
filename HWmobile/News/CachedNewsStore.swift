import Foundation

actor CachedNewsStore {
    private struct Payload: Codable {
        let savedAt: Date
        let articles: [NewsArticleDisplay]
    }

    private let fileManager: FileManager
    private let cacheFileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let folder = (base ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent("news_cache", isDirectory: true)
        self.cacheFileURL = folder.appendingPathComponent("news_articles.json", isDirectory: false)
    }

    func load() throws -> (articles: [NewsArticleDisplay], savedAt: Date)? {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: cacheFileURL)
        let payload = try decoder.decode(Payload.self, from: data)
        if isExpired(savedAt: payload.savedAt) {
            try removeCacheFileIfExists()
            return nil
        }
        return (payload.articles, payload.savedAt)
    }

    func save(_ articles: [NewsArticleDisplay], now: Date = Date()) throws {
        let folder = cacheFileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folder.path) {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        let payload = Payload(savedAt: now, articles: articles)
        let data = try encoder.encode(payload)
        try data.write(to: cacheFileURL, options: .atomic)
    }

    func cleanupIfNeeded(now: Date = Date()) throws {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else {
            return
        }
        let values = try cacheFileURL.resourceValues(forKeys: [.contentModificationDateKey])
        let modifiedAt = values.contentModificationDate ?? now
        let age = now.timeIntervalSince(modifiedAt)
        if age > NewsCachePolicy.maxCacheLifetime {
            try removeCacheFileIfExists()
        }
    }

    private func isExpired(savedAt: Date, now: Date = Date()) -> Bool {
        now.timeIntervalSince(savedAt) > NewsCachePolicy.maxCacheLifetime
    }

    private func removeCacheFileIfExists() throws {
        if fileManager.fileExists(atPath: cacheFileURL.path) {
            try fileManager.removeItem(at: cacheFileURL)
        }
    }
}
