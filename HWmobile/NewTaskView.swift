import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss

    @State private var draft = TaskDraft()
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Информация") {
                    TextField("Название", text: $draft.title)
                    TextField("Описание", text: $draft.details)
                }

                Section("Параметры") {
                    Picker("Приоритет", selection: $draft.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.title)
                                .tag(priority)
                        }
                    }

                    Toggle("Пометить флагом", isOn: $draft.isFlagged)
                }

                Section("Дедлайн") {
                    Toggle("Добавить дату завершения", isOn: $draft.isDueDateEnabled)
                    if draft.isDueDateEnabled {
                        DatePicker("Дата", selection: $draft.dueDate, displayedComponents: .date)
                    }
                }

                if let message = errorMessage {
                    Section {
                        Text(message)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Новая задача")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                    .disabled(!draft.canBeSaved)
                }
            }
        }
    }

    private func save() {
        do {
            _ = try taskManager.createTask(from: draft)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
