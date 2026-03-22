import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var isPresentingNewTask = false

    var body: some View {
        NavigationStack {
            Group {
                if taskManager.tasks.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .padding(.bottom, 8)
                        Text("Задач пока нет")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(taskManager.tasks) { task in
                            TaskRowView(
                                task: task,
                                onToggleCompleted: {
                                    taskManager.toggleCompletion(for: task.id)
                                }
                            )
                        }
                        .onDelete(perform: deleteTasks)
                    }
                }
            }
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingNewTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewTask) {
                NewTaskView()
                    .environmentObject(taskManager)
            }
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = taskManager.tasks[index]
            taskManager.deleteTask(id: task.id)
        }
    }
}
