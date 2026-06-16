import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var taskManager: TaskManager
    @EnvironmentObject private var noteManager: NoteManager

    var body: some View {
        TabView {
            NewsListView()
                .tabItem {
                    Label("Новости", systemImage: "newspaper")
                }
                .accessibilityIdentifier("newsTab")
            NoteListView()
                .environmentObject(noteManager)
                .tabItem {
                    Label("Заметки", systemImage: "note.text")
                }
                .accessibilityIdentifier("notesTab")
            TaskListView()
                .environmentObject(taskManager)
                .tabItem {
                    Label("Задачи", systemImage: "checklist")
                }
                .accessibilityIdentifier("tasksTab")
        }
    }
}
