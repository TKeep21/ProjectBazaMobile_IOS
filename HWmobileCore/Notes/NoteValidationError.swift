import Foundation

public enum NoteValidationError: LocalizedError, Equatable {
    case emptyNote

    public var errorDescription: String? {
        switch self {
        case .emptyNote:
            return "Заметка не может быть пустой."
        }
    }
}
