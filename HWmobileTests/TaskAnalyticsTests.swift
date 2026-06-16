import XCTest
import HWmobileCore
@testable import HWmobile

final class TaskAnalyticsTests: XCTestCase {
    func testAnalyticsCountsTaskStates() {
        let now = Date(timeIntervalSince1970: 2_000)
        let tasks = [
            Task(title: "Active", priority: .low),
            Task(title: "Done", priority: .medium, isCompleted: true),
            Task(title: "Overdue", priority: .high, dueDate: now.addingTimeInterval(-60)),
            Task(title: "High done", priority: .high, isCompleted: true)
        ]

        let analytics = TaskAnalytics.make(from: tasks, now: now)

        XCTAssertEqual(analytics.totalCount, 4)
        XCTAssertEqual(analytics.activeCount, 2)
        XCTAssertEqual(analytics.completedCount, 2)
        XCTAssertEqual(analytics.overdueCount, 1)
        XCTAssertEqual(analytics.highPriorityCount, 2)
        XCTAssertEqual(analytics.completionPercent, 50)
    }

    func testCompletionPercentIsZeroForEmptyTaskList() {
        let analytics = TaskAnalytics.make(from: [])

        XCTAssertEqual(analytics.totalCount, 0)
        XCTAssertEqual(analytics.completionPercent, 0)
    }
}
