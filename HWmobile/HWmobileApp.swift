import SwiftUI

@main
struct HWmobileApp: App {
    @StateObject private var taskVM = TaskViewModel()

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environmentObject(taskVM)  
        }
    }
}
