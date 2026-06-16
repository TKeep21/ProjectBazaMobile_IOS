import Foundation

public struct NoteListQuery: Equatable {
    public var searchText: String

    public init(searchText: String = "") {
        self.searchText = searchText
    }

    public func apply(to notes: [Note]) -> [Note] {
        let sorted = notes.sorted { $0.updatedAt > $1.updatedAt }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return sorted
        }
        return sorted.filter { note in
            note.title.localizedCaseInsensitiveContains(query)
                || note.body.localizedCaseInsensitiveContains(query)
        }
    }
}
