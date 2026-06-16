import Foundation

public enum TaskFilter: String, CaseIterable, Identifiable {
    case all
    case active
    case completed
    case overdue
    case highPriority

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .all:
            return "Все"
        case .active:
            return "Активные"
        case .completed:
            return "Готовые"
        case .overdue:
            return "Просроченные"
        case .highPriority:
            return "Важные"
        }
    }
}
