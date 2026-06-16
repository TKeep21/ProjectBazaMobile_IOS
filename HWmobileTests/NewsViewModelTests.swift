import XCTest
import HWmobileCore
@testable import HWmobile

@MainActor
final class NewsViewModelTests: XCTestCase {
    func testManualRefreshUsesInjectedRepository() async throws {
        let article = NewsArticleDisplay(
            id: "mock-article",
            title: "Mock News",
            abstractText: "Loaded through injected repository.",
            sourceLabel: "Tests",
            publishedAt: nil,
            imageURL: nil
        )
        let result = NewsLoadResult(articles: [article], source: .cache, savedAt: Date())
        let viewModel = NewsViewModel(repository: MockNewsRepository(result: result))

        viewModel.manualRefresh()

        try await waitUntil {
            viewModel.articles == [article]
        }
        XCTAssertEqual(viewModel.sourceBadgeText?.contains("Показан кэш"), true)
        XCTAssertNil(viewModel.errorMessage)
    }

    private func waitUntil(
        timeout: TimeInterval = 3,
        condition: @escaping @MainActor () -> Bool
    ) async throws {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if condition() {
                return
            }
            try await _Concurrency.Task.sleep(nanoseconds: 50_000_000)
        }
        XCTFail("Condition was not fulfilled before timeout.")
    }
}

private actor MockNewsRepository: NewsLoading {
    let result: NewsLoadResult

    init(result: NewsLoadResult) {
        self.result = result
    }

    func loadCached() async -> NewsLoadResult? {
        result
    }

    func refreshFromNetwork(apiKey: String) async throws -> NewsLoadResult {
        result
    }

    func refreshWithFallback(apiKey: String) async throws -> NewsLoadResult {
        result
    }
}
