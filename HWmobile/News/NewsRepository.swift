import Foundation

struct NewsLoadResult {
    let articles: [NewsArticleDisplay]
    let source: NewsDataSource
    let savedAt: Date?
}

actor NewsRepository {
    private let remoteService: NYTimesNewsService
    private let cacheStore: CachedNewsStore

    init(
        remoteService: NYTimesNewsService = NYTimesNewsService(),
        cacheStore: CachedNewsStore = CachedNewsStore()
    ) {
        self.remoteService = remoteService
        self.cacheStore = cacheStore
    }

    func loadCached() async -> NewsLoadResult? {
        do {
            try await cacheStore.cleanupIfNeeded()
            guard let cached = try await cacheStore.load() else {
                return nil
            }
            return NewsLoadResult(articles: cached.articles, source: .cache, savedAt: cached.savedAt)
        } catch {
            return nil
        }
    }

    func refreshFromNetwork(apiKey: String) async throws -> NewsLoadResult {
        let remoteArticles = try await remoteService.fetchHomeTopStories(apiKey: apiKey)
        try await cacheStore.save(remoteArticles)
        return NewsLoadResult(articles: remoteArticles, source: .network, savedAt: Date())
    }

    func refreshWithFallback(apiKey: String) async throws -> NewsLoadResult {
        do {
            return try await refreshFromNetwork(apiKey: apiKey)
        } catch {
            if let cached = await loadCached() {
                return cached
            }
            throw error
        }
    }
}
