

import Foundation

public enum TaskPriority: Int, Codable, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3

    public var title: String {
        switch self {
        case .low: return "Низкий"
        case .medium: return "Средний"
        case .high: return "Высокий"
        }
    }
}

