import XCTest
import HWmobileCore
@testable import HWmobile

final class CachedNewsStoreTests: XCTestCase {
    func testSaveAndLoadArticles() async throws {
        let fileURL = temporaryCacheFileURL()
        defer { try? FileManager.default.removeItem(at: fileURL.deletingLastPathComponent()) }
        let store = CachedNewsStore(cacheFileURL: fileURL)
        let savedAt = Date()
        let article = NewsArticleDisplay(
            id: "article-1",
            title: "Cached Article",
            abstractText: "Saved on disk.",
            sourceLabel: "Tests",
            publishedAt: savedAt,
            imageURL: URL(string: "https://example.com/cached.jpg")
        )

        try await store.save([article], now: savedAt)
        let loaded = try await store.load()

        XCTAssertEqual(loaded?.articles, [article])
        XCTAssertEqual(loaded?.savedAt, savedAt)
    }

    private func temporaryCacheFileURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("HWmobileTests-\(UUID().uuidString)", isDirectory: true)
            .appendingPathComponent("news_articles.json", isDirectory: false)
    }
}
