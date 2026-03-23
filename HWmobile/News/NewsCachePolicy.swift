import Foundation

enum NewsCachePolicy {
    static let freshnessInterval: TimeInterval = 10 * 60
    static let maxCacheLifetime: TimeInterval = 24 * 60 * 60
    static let imageMaxLifetime: TimeInterval = 7 * 24 * 60 * 60
    static let maxImageFileCount: Int = 200
}
