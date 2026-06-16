import SwiftUI
import HWmobileCore

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var isPresentingNewTask = false
    @State private var query = TaskListQuery()

    private var visibleTasks: [Task] {
        query.apply(to: taskManager.tasks)
    }

    private var analytics: TaskAnalytics {
        TaskAnalytics.make(from: taskManager.tasks)
    }

    var body: some View {
        NavigationStack {
            Group {
                if taskManager.tasks.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .padding(.bottom, 8)
                        Text("Задач пока нет")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        TaskAnalyticsView(analytics: analytics)
                            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

                        Section {
                            Picker("Фильтр", selection: $query.filter) {
                                ForEach(TaskFilter.allCases) { filter in
                                    Text(filter.title)
                                        .tag(filter)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        if visibleTasks.isEmpty {
                            ContentUnavailableView(
                                "Ничего не найдено",
                                systemImage: "magnifyingglass",
                                description: Text("Попробуйте изменить поиск или фильтр.")
                            )
                        }

                        ForEach(visibleTasks) { task in
                            TaskRowView(
                                task: task,
                                onToggleCompleted: {
                                    taskManager.toggleCompletion(for: task.id)
                                }
                            )
                            .accessibilityIdentifier("taskRow-\(task.title)")
                        }
                        .onDelete(perform: deleteTasks)
                    }
                }
            }
            .navigationTitle("Задачи")
            .searchable(text: $query.searchText, prompt: "Поиск задач")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingNewTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addTaskButton")
                }
                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        Picker("Сортировка", selection: $query.sortOption) {
                            ForEach(TaskSortOption.allCases) { option in
                                Text(option.title)
                                    .tag(option)
                            }
                        }
                    } label: {
                        Label("Сортировка", systemImage: "arrow.up.arrow.down")
                    }
                    .accessibilityIdentifier("sortTasksButton")
                }
            }
            .sheet(isPresented: $isPresentingNewTask) {
                NewTaskView()
                    .environmentObject(taskManager)
            }
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = visibleTasks[index]
            taskManager.deleteTask(id: task.id)
        }
    }
}

private struct TaskAnalyticsView: View {
    let analytics: TaskAnalytics

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("\(analytics.totalCount)", systemImage: "list.bullet")
                Spacer()
                Label("\(analytics.completionPercent)%", systemImage: "chart.pie")
            }
            .font(.headline)

            ProgressView(value: Double(analytics.completionPercent), total: 100)

            HStack(spacing: 10) {
                MetricPill(title: "Активные", value: analytics.activeCount)
                MetricPill(title: "Готовые", value: analytics.completedCount)
                MetricPill(title: "Просроч.", value: analytics.overdueCount)
                MetricPill(title: "Важные", value: analytics.highPriorityCount)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("taskAnalyticsView")
    }
}

private struct MetricPill: View {
    let title: String
    let value: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.headline)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
