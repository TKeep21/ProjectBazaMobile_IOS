import Foundation

public struct NoteDraft: Equatable {
    public var title: String
    public var body: String

    public init(title: String = "", body: String = "") {
        self.title = title
        self.body = body
    }

    public var canBeSaved: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
