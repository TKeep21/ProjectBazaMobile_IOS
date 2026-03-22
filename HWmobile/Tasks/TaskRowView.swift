import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggleCompleted: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggleCompleted) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .primary)

                HStack(spacing: 8) {
                    Text(task.priority.title)
                        .font(.subheadline)

                    if let dueDate = task.dueDate {
                        Text(dueDate, style: .date)
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.secondary)
            }

            Spacer()

            if task.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundColor(.red)
            }
        }
    }
}
