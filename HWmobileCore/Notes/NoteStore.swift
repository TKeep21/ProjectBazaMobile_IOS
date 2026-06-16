import Foundation

public struct NoteStore {
    public private(set) var notes: [Note]

    public init(initialNotes: [Note] = []) {
        self.notes = initialNotes
    }

    @discardableResult
    public mutating func createNote(from draft: NoteDraft, now: Date = Date()) throws -> Note {
        let normalized = try normalize(draft: draft)
        let note = Note(
            title: normalized.title,
            body: normalized.body,
            createdAt: now,
            updatedAt: now
        )
        notes.append(note)
        return note
    }

    public mutating func updateNote(id: UUID, draft: NoteDraft, now: Date = Date()) throws {
        guard let index = notes.firstIndex(where: { $0.id == id }) else {
            return
        }
        let normalized = try normalize(draft: draft)
        notes[index].title = normalized.title
        notes[index].body = normalized.body
        notes[index].updatedAt = now
    }

    public mutating func deleteNote(id: UUID) {
        notes.removeAll { $0.id == id }
    }

    private func normalize(draft: NoteDraft) throws -> (title: String, body: String) {
        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = draft.body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty || !body.isEmpty else {
            throw NoteValidationError.emptyNote
        }
        return (title.isEmpty ? makeTitle(from: body) : title, body)
    }

    private func makeTitle(from body: String) -> String {
        let firstLine = body
            .components(separatedBy: .newlines)
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if firstLine.count <= 40 {
            return firstLine.isEmpty ? "Без названия" : firstLine
        }
        return String(firstLine.prefix(40)) + "..."
    }
}
