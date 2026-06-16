import XCTest
import HWmobileCore
@testable import HWmobile

final class NoteListQueryTests: XCTestCase {
    func testApplySortsByUpdatedAtDescending() {
        let old = Note(
            title: "Old",
            body: "",
            updatedAt: Date(timeIntervalSince1970: 10)
        )
        let new = Note(
            title: "New",
            body: "",
            updatedAt: Date(timeIntervalSince1970: 20)
        )
        let query = NoteListQuery()

        XCTAssertEqual(query.apply(to: [old, new]), [new, old])
    }

    func testApplySearchesTitleAndBody() {
        let first = Note(title: "Swift", body: "UI")
        let second = Note(title: "Другое", body: "Compose заметка")
        let third = Note(title: "Планы", body: "Учеба")
        let query = NoteListQuery(searchText: "compose")

        XCTAssertEqual(query.apply(to: [first, second, third]), [second])
    }
}
