import Combine
import Foundation
import HWmobileCore

final class NoteManager: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published private(set) var persistenceErrorMessage: String?

    private var store: NoteStore
    private let persistence: NoteFileStore

    init(initialNotes: [Note] = [], persistence: NoteFileStore = .live()) {
        self.persistence = persistence
        let restoredNotes: [Note]
        if initialNotes.isEmpty {
            do {
                restoredNotes = try persistence.loadNotes()
            } catch {
                restoredNotes = []
                persistenceErrorMessage = "Не удалось загрузить сохраненные заметки."
            }
        } else {
            restoredNotes = initialNotes
        }
        self.store = NoteStore(initialNotes: restoredNotes)
        self.notes = store.notes
    }

    @discardableResult
    func createNote(from draft: NoteDraft) throws -> Note {
        let note = try store.createNote(from: draft)
        syncNotes()
        return note
    }

    func updateNote(id: UUID, draft: NoteDraft) throws {
        try store.updateNote(id: id, draft: draft)
        syncNotes()
    }

    func deleteNote(id: UUID) {
        store.deleteNote(id: id)
        syncNotes()
    }

    private func syncNotes() {
        notes = store.notes
        do {
            try persistence.saveNotes(notes)
            persistenceErrorMessage = nil
        } catch {
            persistenceErrorMessage = "Не удалось сохранить заметки."
        }
    }
}
