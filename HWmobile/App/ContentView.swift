import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var taskManager: TaskManager

    var body: some View {
        MainTabView()
            .environmentObject(taskManager)
    }
}
