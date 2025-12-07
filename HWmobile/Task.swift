import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var details: String?
    var priority: TaskPriority
    var isFlagged: Bool
    var dueDate: Date?
    var isCompleted: Bool
    let createdAt: Date

    init(
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
