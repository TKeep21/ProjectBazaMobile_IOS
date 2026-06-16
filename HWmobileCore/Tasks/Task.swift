import Foundation

public struct Task: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var details: String?
    public var priority: TaskPriority
    public var isFlagged: Bool
    public var dueDate: Date?
    public var isCompleted: Bool
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        details: String? = nil,
        priority: TaskPriority,
        isFlagged: Bool = false,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.priority = priority
        self.isFlagged = isFlagged
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
