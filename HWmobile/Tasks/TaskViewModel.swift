import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    @Published private(set) var tasks: [Task] = []

    init(sampleData: Bool = false) {
        if sampleData {
            tasks = [
                Task(title: "Пример задачи", details: "Описание", priority: .medium),
                Task(title: "Учеба", details: "Почитать лекцию", priority: .high)
            ]
        }
    }

    func add(_ task: Task) {
        tasks.append(task)
    }

    func update(_ task: Task) {
        if let i = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[i] = task
        }
    }

    func toggleComplete(_ task: Task) {
        guard var t = tasks.first(where: { $0.id == task.id }) else { return }
        t.isCompleted.toggle()
        update(t)
    }

    func remove(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    
    func sortByPriorityDescending() {
        tasks.sort { $0.priority.rawValue > $1.priority.rawValue }
    }
}
