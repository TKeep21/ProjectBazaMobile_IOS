import Foundation

enum TaskValidationError: LocalizedError {
    case emptyTitle

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Название задачи не может быть пустым."
        }
    }
}
