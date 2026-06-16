import Foundation

public enum TaskValidationError: LocalizedError, Equatable {
    case emptyTitle

    public var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Название задачи не может быть пустым."
        }
    }
}
