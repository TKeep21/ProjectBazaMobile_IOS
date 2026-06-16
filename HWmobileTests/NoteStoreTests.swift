import XCTest
import HWmobileCore
@testable import HWmobile

final class NoteStoreTests: XCTestCase {
    func testCreateNoteTrimsTitleAndBody() throws {
        var store = NoteStore()
        let now = Date(timeIntervalSince1970: 100)
        let draft = NoteDraft(title: "  Идея  ", body: "  Текст заметки  ")

        let note = try store.createNote(from: draft, now: now)

        XCTAssertEqual(note.title, "Идея")
        XCTAssertEqual(note.body, "Текст заметки")
        XCTAssertEqual(note.createdAt, now)
        XCTAssertEqual(note.updatedAt, now)
        XCTAssertEqual(store.notes, [note])
    }

    func testCreateNoteUsesFirstBodyLineAsTitleWhenTitleIsEmpty() throws {
        var store = NoteStore()
        let draft = NoteDraft(title: "   ", body: "Первая строка\nДетали")

        let note = try store.createNote(from: draft)

        XCTAssertEqual(note.title, "Первая строка")
        XCTAssertEqual(note.body, "Первая строка\nДетали")
    }

    func testCreateNoteRejectsEmptyDraft() {
        var store = NoteStore()
        let draft = NoteDraft(title: "   ", body: "  ")

        XCTAssertThrowsError(try store.createNote(from: draft)) { error in
            XCTAssertEqual(error as? NoteValidationError, .emptyNote)
        }
        XCTAssertTrue(store.notes.isEmpty)
    }

    func testUpdateNoteChangesUpdatedAt() throws {
        let original = Note(
            id: UUID(),
            title: "Old",
            body: "Old body",
            createdAt: Date(timeIntervalSince1970: 10),
            updatedAt: Date(timeIntervalSince1970: 10)
        )
        var store = NoteStore(initialNotes: [original])
        let updatedAt = Date(timeIntervalSince1970: 20)

        try store.updateNote(
            id: original.id,
            draft: NoteDraft(title: "New", body: "New body"),
            now: updatedAt
        )

        XCTAssertEqual(store.notes[0].title, "New")
        XCTAssertEqual(store.notes[0].body, "New body")
        XCTAssertEqual(store.notes[0].createdAt, original.createdAt)
        XCTAssertEqual(store.notes[0].updatedAt, updatedAt)
    }
}
