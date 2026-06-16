import SwiftUI
import HWmobileCore

struct NoteEditorView: View {
    @EnvironmentObject private var noteManager: NoteManager
    @Environment(\.dismiss) private var dismiss

    let route: NoteEditorRoute
    @State private var draft: NoteDraft
    @State private var errorMessage: String?

    init(route: NoteEditorRoute) {
        self.route = route
        switch route {
        case .create:
            _draft = State(initialValue: NoteDraft())
        case .edit(let note):
            _draft = State(initialValue: NoteDraft(title: note.title, body: note.body))
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Заметка") {
                    TextField("Заголовок", text: $draft.title)
                        .accessibilityIdentifier("noteTitleField")
                    TextEditor(text: $draft.body)
                        .frame(minHeight: 180)
                        .accessibilityIdentifier("noteBodyEditor")
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(navigationTitle)
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
                    .accessibilityIdentifier("saveNoteButton")
                }
            }
        }
    }

    private var navigationTitle: String {
        switch route {
        case .create:
            return "Новая заметка"
        case .edit:
            return "Редактировать"
        }
    }

    private func save() {
        do {
            switch route {
            case .create:
                _ = try noteManager.createNote(from: draft)
            case .edit(let note):
                try noteManager.updateNote(id: note.id, draft: draft)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
