import XCTest
import HWmobileCore
@testable import HWmobile

final class TaskListQueryTests: XCTestCase {
    func testSearchMatchesTitle() {
        let tasks = makeTasks()
        let query = TaskListQuery(searchText: "лекция")

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Лекция по iOS"])
    }

    func testSearchMatchesDetails() {
        let tasks = makeTasks()
        let query = TaskListQuery(searchText: "api")

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Новости"])
    }

    func testActiveFilterReturnsOnlyIncompleteTasks() {
        let tasks = makeTasks()
        let query = TaskListQuery(filter: .active)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Просроченный отчет", "Новости", "Лекция по iOS"])
    }

    func testCompletedFilterReturnsOnlyCompletedTasks() {
        let tasks = makeTasks()
        let query = TaskListQuery(filter: .completed)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Сдать домашку"])
    }

    func testOverdueFilterIgnoresCompletedTasks() {
        let tasks = makeTasks()
        let query = TaskListQuery(filter: .overdue)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Просроченный отчет"])
    }

    func testHighPriorityFilterReturnsOnlyHighPriorityTasks() {
        let tasks = makeTasks()
        let query = TaskListQuery(filter: .highPriority)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Просроченный отчет", "Сдать домашку"])
    }

    func testPrioritySortOrdersHighPriorityFirst() {
        let tasks = makeTasks()
        let query = TaskListQuery(sortOption: .priority)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Просроченный отчет", "Сдать домашку", "Новости", "Лекция по iOS"])
    }

    func testDueDateSortPutsDatedTasksFirst() {
        let tasks = makeTasks()
        let query = TaskListQuery(sortOption: .dueDate)

        let result = query.apply(to: tasks, now: Self.now)

        XCTAssertEqual(result.map(\.title), ["Просроченный отчет", "Сдать домашку", "Лекция по iOS", "Новости"])
    }

    private func makeTasks() -> [Task] {
        [
            Task(
                title: "Лекция по iOS",
                details: "Повторить SwiftUI",
                priority: .low,
                dueDate: Self.now.addingTimeInterval(3_600),
                createdAt: Self.now.addingTimeInterval(-400)
            ),
            Task(
                title: "Сдать домашку",
                details: "Проверить тесты",
                priority: .high,
                dueDate: Self.now.addingTimeInterval(1_800),
                isCompleted: true,
                createdAt: Self.now.addingTimeInterval(-300)
            ),
            Task(
                title: "Новости",
                details: "Проверить API и кэш",
                priority: .medium,
                createdAt: Self.now.addingTimeInterval(-200)
            ),
            Task(
                title: "Просроченный отчет",
                details: "Закрыть хвосты",
                priority: .high,
                dueDate: Self.now.addingTimeInterval(-1_800),
                createdAt: Self.now.addingTimeInterval(-100)
            )
        ]
    }

    private static let now = Date(timeIntervalSince1970: 2_000)
}
