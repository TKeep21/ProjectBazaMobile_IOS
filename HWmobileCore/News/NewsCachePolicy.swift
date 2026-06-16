import Foundation

public enum NewsCachePolicy {
    nonisolated public static let freshnessInterval: TimeInterval = 10 * 60
    nonisolated public static let maxCacheLifetime: TimeInterval = 24 * 60 * 60
    nonisolated public static let imageMaxLifetime: TimeInterval = 7 * 24 * 60 * 60
    nonisolated public static let maxImageFileCount: Int = 200
}
