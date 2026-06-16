import Foundation

public struct TaskStore {
    public private(set) var tasks: [Task]

    public init(initialTasks: [Task] = []) {
        self.tasks = initialTasks
    }

    @discardableResult
    public mutating func createTask(from draft: TaskDraft) throws -> Task {
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

    public mutating func updateTask(id: UUID, transform: (inout Task) -> Void) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }

        var task = tasks[index]
        transform(&task)
        tasks[index] = task
    }

    public mutating func replaceTask(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        tasks[index] = task
    }

    public mutating func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    public mutating func toggleCompletion(for id: UUID) {
        updateTask(id: id) { task in
            task.isCompleted.toggle()
        }
    }

    public var hasTasks: Bool {
        !tasks.isEmpty
    }
}
