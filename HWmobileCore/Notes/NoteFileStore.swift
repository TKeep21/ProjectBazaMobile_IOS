import Foundation

nonisolated public struct NoteFileStore {
    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(fileURL: URL, fileManager: FileManager = .default) {
        self.fileURL = fileURL
        self.fileManager = fileManager
    }

    public static func live(fileManager: FileManager = .default) -> NoteFileStore {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folder = (base ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent("HWmobile", isDirectory: true)
        return NoteFileStore(
            fileURL: folder.appendingPathComponent("notes.json", isDirectory: false),
            fileManager: fileManager
        )
    }

    public func loadNotes() throws -> [Note] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Note].self, from: data)
    }

    public func saveNotes(_ notes: [Note]) throws {
        let folder = fileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folder.path) {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        let data = try encoder.encode(notes)
        try data.write(to: fileURL, options: .atomic)
    }
}
