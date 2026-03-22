import Foundation
import Combine

final class TaskManager: ObservableObject {
    @Published private(set) var tasks: [Task] = []

    init(initialTasks: [Task] = []) {
        self.tasks = initialTasks
    }

    @discardableResult
    func createTask(from draft: TaskDraft) throws -> Task {
        let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw TaskValidationError.emptyTitle
        }

        let trimmedDetails = draft.details.trimmingCharacters(in: .whitespacesAndNewlines)
        let detailsValue = trimmedDetails.isEmpty ? nil : trimmedDetails
        let dueDateValue = draft.isDueDateEnabled ? draft.dueDate : nil

        let task = Task(
            title: trimmedTitle,
            details: detailsValue,
            priority: draft.priority,
            isFlagged: draft.isFlagged,
            dueDate: dueDateValue
        )

        tasks.append(task)
        return task
    }

    func updateTask(id: UUID, transform: (inout Task) -> Void) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }

        var task = tasks[index]
        transform(&task)
        tasks[index] = task
    }

    func replaceTask(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        tasks[index] = task
    }

    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    func toggleCompletion(for id: UUID) {
        updateTask(id: id) { task in
            task.isCompleted.toggle()
        }
    }

    var hasTasks: Bool {
        !tasks.isEmpty
    }
}
