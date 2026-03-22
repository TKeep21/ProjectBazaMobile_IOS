import SwiftUI

struct TaskRow: View {
    @EnvironmentObject private var vm: TaskViewModel
    var task: Task

    var body: some View {
        HStack(spacing: 12) {
            Button {
                vm.toggleComplete(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted)

                    if task.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    }

                    Spacer()

                    Text(task.priority.title)
                        .font(.caption)
                        .padding(4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }

                if let details = task.details, !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let due = task.dueDate {
                    Text("Due: \(due.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
