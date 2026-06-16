import Foundation

public struct TaskDraft {
    public var title: String
    public var details: String
    public var priority: TaskPriority
    public var isFlagged: Bool
    public var isDueDateEnabled: Bool
    public var dueDate: Date

    public init(
        title: String = "",
        details: String = "",
        priority: TaskPriority = .medium,
        isFlagged: Bool = false,
        isDueDateEnabled: Bool = false,
        dueDate: Date = Date()
    ) {
        self.title = title
        self.details = details
        self.priority = priority
        self.isFlagged = isFlagged
        self.isDueDateEnabled = isDueDateEnabled
        self.dueDate = dueDate
    }

    public var canBeSaved: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
