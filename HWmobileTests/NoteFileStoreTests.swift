import XCTest
import HWmobileCore
@testable import HWmobile

final class NoteFileStoreTests: XCTestCase {
    func testSaveAndLoadNotes() throws {
        let fileURL = temporaryFileURL()
        defer { try? FileManager.default.removeItem(at: fileURL.deletingLastPathComponent()) }
        let store = NoteFileStore(fileURL: fileURL)
        let note = Note(title: "Сохранить", body: "Проверить восстановление")

        try store.saveNotes([note])

        XCTAssertEqual(try store.loadNotes(), [note])
    }

    func testLoadReturnsEmptyWhenFileDoesNotExist() throws {
        let store = NoteFileStore(fileURL: temporaryFileURL())

        XCTAssertEqual(try store.loadNotes(), [])
    }

    private func temporaryFileURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("HWmobileTests-\(UUID().uuidString)", isDirectory: true)
            .appendingPathComponent("notes.json", isDirectory: false)
    }
}
