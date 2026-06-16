import Foundation
import HWmobileCore
import Combine

final class TaskManager: ObservableObject {
    @Published private(set) var tasks: [Task] = []
    @Published private(set) var persistenceErrorMessage: String?
    private var store: TaskStore
    private let persistence: TaskFileStore

    init(initialTasks: [Task] = [], persistence: TaskFileStore = .live()) {
        self.persistence = persistence
        let restoredTasks: [Task]
        if initialTasks.isEmpty {
            do {
                restoredTasks = try persistence.loadTasks()
            } catch {
                restoredTasks = []
                persistenceErrorMessage = "Не удалось загрузить сохраненные задачи."
            }
        } else {
            restoredTasks = initialTasks
        }
        self.store = TaskStore(initialTasks: restoredTasks)
        self.tasks = store.tasks
    }

    @discardableResult
    func createTask(from draft: TaskDraft) throws -> Task {
        let task = try store.createTask(from: draft)
        syncTasks()
        return task
    }

    func updateTask(id: UUID, transform: (inout Task) -> Void) {
        store.updateTask(id: id, transform: transform)
        syncTasks()
    }

    func replaceTask(_ task: Task) {
        store.replaceTask(task)
        syncTasks()
    }

    func deleteTask(id: UUID) {
        store.deleteTask(id: id)
        syncTasks()
    }

    func toggleCompletion(for id: UUID) {
        store.toggleCompletion(for: id)
        syncTasks()
    }

    var hasTasks: Bool {
        !tasks.isEmpty
    }

    private func syncTasks() {
        tasks = store.tasks
        do {
            try persistence.saveTasks(tasks)
            persistenceErrorMessage = nil
        } catch {
            persistenceErrorMessage = "Не удалось сохранить задачи."
        }
    }
}
