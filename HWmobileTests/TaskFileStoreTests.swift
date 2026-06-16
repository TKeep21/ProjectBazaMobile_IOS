import XCTest
import HWmobileCore
@testable import HWmobile

final class TaskFileStoreTests: XCTestCase {
    func testLoadReturnsEmptyArrayWhenFileDoesNotExist() throws {
        let store = TaskFileStore(fileURL: temporaryFileURL())

        let tasks = try store.loadTasks()

        XCTAssertTrue(tasks.isEmpty)
    }

    func testSaveAndLoadTasks() throws {
        let fileURL = temporaryFileURL()
        defer { try? FileManager.default.removeItem(at: fileURL.deletingLastPathComponent()) }
        let store = TaskFileStore(fileURL: fileURL)
        let tasks = [
            Task(
                id: UUID(),
                title: "Сохраненная задача",
                details: "Проверить JSON persistence",
                priority: .high,
                isFlagged: true,
                dueDate: Date(timeIntervalSince1970: 2_000),
                createdAt: Date(timeIntervalSince1970: 1_000)
            )
        ]

        try store.saveTasks(tasks)
        let loaded = try store.loadTasks()

        XCTAssertEqual(loaded, tasks)
    }

    private func temporaryFileURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("HWmobileTaskStoreTests-\(UUID().uuidString)", isDirectory: true)
            .appendingPathComponent("tasks.json", isDirectory: false)
    }
}
