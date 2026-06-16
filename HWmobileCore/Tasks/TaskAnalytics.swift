import Foundation

public struct TaskAnalytics: Equatable {
    public let totalCount: Int
    public let activeCount: Int
    public let completedCount: Int
    public let overdueCount: Int
    public let highPriorityCount: Int

    public var completionPercent: Int {
        guard totalCount > 0 else {
            return 0
        }
        return Int((Double(completedCount) / Double(totalCount) * 100).rounded())
    }

    public static func make(from tasks: [Task], now: Date = Date()) -> TaskAnalytics {
        let completed = tasks.filter(\.isCompleted).count
        let overdue = tasks.filter { task in
            guard let dueDate = task.dueDate else {
                return false
            }
            return !task.isCompleted && dueDate < now
        }.count

        return TaskAnalytics(
            totalCount: tasks.count,
            activeCount: tasks.count - completed,
            completedCount: completed,
            overdueCount: overdue,
            highPriorityCount: tasks.filter { $0.priority == .high }.count
        )
    }
}
