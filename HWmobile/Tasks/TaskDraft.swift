import Foundation

struct TaskDraft {
    var title: String = ""
    var details: String = ""
    var priority: TaskPriority = .medium
    var isFlagged: Bool = false
    var isDueDateEnabled: Bool = false
    var dueDate: Date = Date()

    var canBeSaved: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
