import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var taskManager: TaskManager

    var body: some View {
        TabView {
            NewsListView()
                .tabItem {
                    Label("Новости", systemImage: "newspaper")
                }
            TaskListView()
                .environmentObject(taskManager)
                .tabItem {
                    Label("Задачи", systemImage: "checklist")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(TaskManager())
}
