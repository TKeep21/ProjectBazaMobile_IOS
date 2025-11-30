import SwiftUI

struct CreateTaskView: View {
    @EnvironmentObject private var vm: TaskViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var details: String = ""
    @State private var priority: Task.Priority = .medium
    @State private var flagged: Bool = false
    @State private var useDueDate: Bool = false
    @State private var dueDate: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Основное")) {
                    TextField("Название задачи *", text: $title)
                    TextField("Описание (опционально)", text: $details)
                }

                Section(header: Text("Приоритет")) {
                    Picker("Приоритет", selection: $priority) {
                        ForEach(Task.Priority.allCases) { p in
                            Text(p.title).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Toggle("Флаг", isOn: $flagged)
                    Toggle("Выбрать дату завершения", isOn: $useDueDate)
                    if useDueDate {
                        DatePicker("Дата и время", selection: $dueDate)
                    }
                }

                Section {
                    Button(action: save) {
                        HStack {
                            Spacer()
                            Text("Сохранить")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Новая задача")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let task = Task(title: trimmed,
                        details: details.isEmpty ? nil : details,
                        priority: priority,
                        flagged: flagged,
                        dueDate: useDueDate ? dueDate : nil)
        vm.add(task)
        dismiss()
    }
}
