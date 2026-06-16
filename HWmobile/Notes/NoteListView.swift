import SwiftUI
import HWmobileCore

struct NoteListView: View {
    @EnvironmentObject private var noteManager: NoteManager
    @State private var query = NoteListQuery()
    @State private var editorRoute: NoteEditorRoute?

    private var visibleNotes: [Note] {
        query.apply(to: noteManager.notes)
    }

    var body: some View {
        NavigationStack {
            Group {
                if noteManager.notes.isEmpty {
                    ContentUnavailableView(
                        "Заметок пока нет",
                        systemImage: "note.text",
                        description: Text("Добавьте идею, мысль или короткую памятку.")
                    )
                } else {
                    List {
                        if visibleNotes.isEmpty {
                            ContentUnavailableView(
                                "Ничего не найдено",
                                systemImage: "magnifyingglass",
                                description: Text("Попробуйте изменить текст поиска.")
                            )
                        }
                        ForEach(visibleNotes) { note in
                            Button {
                                editorRoute = .edit(note)
                            } label: {
                                NoteRowView(note: note)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("noteRow-\(note.title)")
                        }
                        .onDelete(perform: deleteNotes)
                    }
                }
            }
            .navigationTitle("Заметки")
            .searchable(text: $query.searchText, prompt: "Поиск заметок")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        editorRoute = .create
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addNoteButton")
                }
            }
            .sheet(item: $editorRoute) { route in
                NoteEditorView(route: route)
                    .environmentObject(noteManager)
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            noteManager.deleteNote(id: visibleNotes[index].id)
        }
    }
}

private struct NoteRowView: View {
    let note: Note

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)
            if !note.body.isEmpty {
                Text(note.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(Self.dateFormatter.string(from: note.updatedAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

enum NoteEditorRoute: Identifiable {
    case create
    case edit(Note)

    var id: String {
        switch self {
        case .create:
            return "create"
        case .edit(let note):
            return note.id.uuidString
        }
    }
}
