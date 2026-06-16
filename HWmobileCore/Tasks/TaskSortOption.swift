import Foundation

public enum TaskSortOption: String, CaseIterable, Identifiable {
    case createdAt
    case priority
    case dueDate

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .createdAt:
            return "Создание"
        case .priority:
            return "Приоритет"
        case .dueDate:
            return "Дедлайн"
        }
    }
}
