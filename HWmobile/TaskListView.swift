import SwiftUI

struct TaskListView: View {
    @EnvironmentObject private var vm: TaskViewModel
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Text("Задач нет")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Нажмите + чтобы добавить новую задачу")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    List {
                        ForEach(vm.tasks) { task in
                            TaskRow(task: task)
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Задачи")
            .toolbar {
  
                Button {
                    showingCreate = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreateTaskView()
                    .environmentObject(vm)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.map { vm.tasks[$0] }.forEach { vm.remove($0) }
    }
}
