import SwiftUI
import HWmobileCore

@main
struct HWmobileApp: App {
    @StateObject private var taskManager: TaskManager

    init() {
        _taskManager = StateObject(wrappedValue: TaskManager(persistence: Self.makeTaskPersistence()))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(taskManager)
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
}
