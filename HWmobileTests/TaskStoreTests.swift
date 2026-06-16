import XCTest
import HWmobileCore
@testable import HWmobile

final class TaskStoreTests: XCTestCase {
    func testCreateTaskTrimsTitleAndDetails() throws {
        var store = TaskStore()
        let dueDate = Date(timeIntervalSince1970: 1_800)
        let draft = TaskDraft(
            title: "  Купить молоко  ",
            details: "  После учебы  ",
            priority: .high,
            isFlagged: true,
            isDueDateEnabled: true,
            dueDate: dueDate
        )

        let task = try store.createTask(from: draft)

        XCTAssertEqual(task.title, "Купить молоко")
        XCTAssertEqual(task.details, "После учебы")
        XCTAssertEqual(task.priority, .high)
        XCTAssertTrue(task.isFlagged)
        XCTAssertEqual(task.dueDate, dueDate)
        XCTAssertEqual(store.tasks, [task])
    }

    func testCreateTaskRejectsEmptyTitle() {
        var store = TaskStore()
        let draft = TaskDraft(title: "   ")

        XCTAssertThrowsError(try store.createTask(from: draft)) { error in
            XCTAssertEqual(error as? TaskValidationError, .emptyTitle)
        }
        XCTAssertTrue(store.tasks.isEmpty)
    }

    func testCreateTaskConvertsEmptyDetailsToNil() throws {
        var store = TaskStore()
        let draft = TaskDraft(title: "Задача", details: "   ")

        let task = try store.createTask(from: draft)

        XCTAssertNil(task.details)
    }

    func testToggleCompletionUpdatesOnlyMatchingTask() {
        let first = Task(id: UUID(), title: "Первая", priority: .low)
        let second = Task(id: UUID(), title: "Вторая", priority: .medium)
        var store = TaskStore(initialTasks: [first, second])

        store.toggleCompletion(for: first.id)

        XCTAssertTrue(store.tasks[0].isCompleted)
        XCTAssertFalse(store.tasks[1].isCompleted)
    }

    func testDeleteTaskRemovesMatchingTask() {
        let first = Task(id: UUID(), title: "Первая", priority: .low)
        let second = Task(id: UUID(), title: "Вторая", priority: .medium)
        var store = TaskStore(initialTasks: [first, second])

        store.deleteTask(id: first.id)

        XCTAssertEqual(store.tasks, [second])
    }
}
