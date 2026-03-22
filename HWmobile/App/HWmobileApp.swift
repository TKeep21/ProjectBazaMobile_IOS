import SwiftUI

@main
struct HWmobileApp: App {
    @StateObject private var taskManager = TaskManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(taskManager)
        }
    }
}
