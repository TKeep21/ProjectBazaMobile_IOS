import Foundation

public struct TaskListQuery: Equatable {
    public var searchText: String
    public var filter: TaskFilter
    public var sortOption: TaskSortOption

    public init(searchText: String = "", filter: TaskFilter = .all, sortOption: TaskSortOption = .createdAt) {
        self.searchText = searchText
        self.filter = filter
        self.sortOption = sortOption
    }

    public func apply(to tasks: [Task], now: Date = Date()) -> [Task] {
        let searched = applySearch(to: tasks)
        let filtered = applyFilter(to: searched, now: now)
        return applySort(to: filtered)
    }

    private func applySearch(to tasks: [Task]) -> [Task] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return tasks
        }

        return tasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query)
                || (task.details?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    private func applyFilter(to tasks: [Task], now: Date) -> [Task] {
        switch filter {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter(\.isCompleted)
        case .overdue:
            return tasks.filter { task in
                guard let dueDate = task.dueDate else {
                    return false
                }
                return !task.isCompleted && dueDate < now
            }
        case .highPriority:
            return tasks.filter { $0.priority == .high }
        }
    }

    private func applySort(to tasks: [Task]) -> [Task] {
        switch sortOption {
        case .createdAt:
            return tasks.sorted { $0.createdAt > $1.createdAt }
        case .priority:
            return tasks.sorted {
                if $0.priority.rawValue == $1.priority.rawValue {
                    return $0.createdAt > $1.createdAt
                }
                return $0.priority.rawValue > $1.priority.rawValue
            }
        case .dueDate:
            return tasks.sorted {
                switch ($0.dueDate, $1.dueDate) {
                case let (lhs?, rhs?):
                    return lhs < rhs
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                case (nil, nil):
                    return $0.createdAt > $1.createdAt
                }
            }
        }
    }
}
