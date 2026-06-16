import SwiftUI
import HWmobileCore

@main
struct HWmobileApp: App {
    @StateObject private var taskManager: TaskManager
    @StateObject private var noteManager: NoteManager

    init() {
        _taskManager = StateObject(wrappedValue: TaskManager(persistence: Self.makeTaskPersistence()))
        _noteManager = StateObject(wrappedValue: NoteManager(persistence: Self.makeNotePersistence()))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(taskManager)
                .environmentObject(noteManager)
        }
    }

    private static func makeTaskPersistence() -> TaskFileStore {
        if ProcessInfo.processInfo.arguments.contains("-UITestMode") {
            let fileURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("HWmobileUITests", isDirectory: true)
                .appendingPathComponent("tasks.json", isDirectory: false)
            try? FileManager.default.removeItem(at: fileURL)
            return TaskFileStore(fileURL: fileURL)
        }
        return .live()
    }

    private static func makeNotePersistence() -> NoteFileStore {
        if ProcessInfo.processInfo.arguments.contains("-UITestMode") {
            let fileURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("HWmobileUITests", isDirectory: true)
                .appendingPathComponent("notes.json", isDirectory: false)
            try? FileManager.default.removeItem(at: fileURL)
            return NoteFileStore(fileURL: fileURL)
        }
        return .live()
    }
}
