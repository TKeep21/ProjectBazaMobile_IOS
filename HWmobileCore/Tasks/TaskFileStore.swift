import Foundation

nonisolated public struct TaskFileStore {
    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(fileURL: URL, fileManager: FileManager = .default) {
        self.fileURL = fileURL
        self.fileManager = fileManager
    }

    public static func live(fileManager: FileManager = .default) -> TaskFileStore {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folder = (base ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent("HWmobile", isDirectory: true)
        return TaskFileStore(
            fileURL: folder.appendingPathComponent("tasks.json", isDirectory: false),
            fileManager: fileManager
        )
    }

    public func loadTasks() throws -> [Task] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Task].self, from: data)
    }

    public func saveTasks(_ tasks: [Task]) throws {
        let folder = fileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folder.path) {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        let data = try encoder.encode(tasks)
        try data.write(to: fileURL, options: .atomic)
    }
}
