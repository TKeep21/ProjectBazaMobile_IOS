import Foundation

// Модель задачи
struct Task: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var details: String?
    var priority: Priority
    var flagged: Bool
    var dueDate: Date?
    var isCompleted: Bool

    init(id: UUID = UUID(),
         title: String,
         details: String? = nil,
         priority: Priority = .medium,
         flagged: Bool = false,
         dueDate: Date? = nil,
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.priority = priority
        self.flagged = flagged
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }

    enum Priority: Int, CaseIterable, Codable, Identifiable {
        case low = 0
        case medium = 1
        case high = 2

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            }
        }
    }
}
