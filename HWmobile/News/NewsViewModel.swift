import Combine
import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [NewsArticleDisplay] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var sourceBadgeText: String?

    private let repository = NewsRepository()
    private var refreshLoopTask: _Concurrency.Task<Void, Never>?
    private var didFireBonusPost = false
    private var firstNetworkRefreshDone = false

    deinit {
        refreshLoopTask?.cancel()
    }

    func onAppear() {
        _Concurrency.Task { [weak self] in
            await self?.applyCachedSnapshotIfNeeded()
        }
        startPeriodicRefreshIfNeeded()
        fireBonusPostOnce()
    }

    func onDisappear() {
        refreshLoopTask?.cancel()
        refreshLoopTask = nil
    }

    func manualRefresh() {
        _Concurrency.Task { [weak self] in
            await self?.loadNews(forceAllowCacheFallback: true)
        }
    }

    private func startPeriodicRefreshIfNeeded() {
        guard refreshLoopTask == nil else {
            return
        }
        refreshLoopTask = _Concurrency.Task { [weak self] in
            while !_Concurrency.Task.isCancelled {
                guard let self else {
                    break
                }
                await self.loadNews(forceAllowCacheFallback: self.firstNetworkRefreshDone)
                do {
                    try await _Concurrency.Task.sleep(nanoseconds: 120 * 1_000_000_000)
                } catch {
                    break
                }
            }
        }
    }

    private func fireBonusPostOnce() {
        guard !didFireBonusPost else {
            return
        }
        didFireBonusPost = true
        _Concurrency.Task {
            await BonusJSONPostClient.sendSamplePost()
        }
    }

    private func applyCachedSnapshotIfNeeded() async {
        guard articles.isEmpty else {
            return
        }
        guard let cached = await repository.loadCached(), !cached.articles.isEmpty else {
            return
        }
        articles = cached.articles
        sourceBadgeText = Self.makeSourceBadge(source: cached.source, savedAt: cached.savedAt)
        errorMessage = nil
    }

    private func loadNews(forceAllowCacheFallback: Bool) async {
        let shouldShowBlockingLoader = articles.isEmpty
        if shouldShowBlockingLoader {
            isLoading = true
        }
        defer {
            if shouldShowBlockingLoader {
                isLoading = false
            }
        }
        guard let key = NYTimesAPIConfig.resolvedAPIKey() else {
            if let cached = await repository.loadCached(), !cached.articles.isEmpty {
                articles = cached.articles
                sourceBadgeText = Self.makeSourceBadge(source: cached.source, savedAt: cached.savedAt)
                errorMessage = nil
                return
            }
            errorMessage = NewsServiceError.missingAPIKey.errorDescription
            return
        }
        firstNetworkRefreshDone = true
        do {
            let result: NewsLoadResult
            if forceAllowCacheFallback {
                result = try await repository.refreshWithFallback(apiKey: key)
            } else {
                result = try await repository.refreshFromNetwork(apiKey: key)
            }
            articles = result.articles
            sourceBadgeText = Self.makeSourceBadge(source: result.source, savedAt: result.savedAt)
            errorMessage = nil
        } catch {
            if articles.isEmpty {
                if let localized = error as? LocalizedError, let description = localized.errorDescription {
                    errorMessage = description
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private static func makeSourceBadge(source: NewsDataSource, savedAt: Date?) -> String? {
        switch source {
        case .network:
            return nil
        case .cache:
            if let savedAt {
                let formatter = RelativeDateTimeFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                let delta = formatter.localizedString(for: savedAt, relativeTo: Date())
                return "Показан кэш (\(delta))"
            }
            return "Показан кэш"
        }
    }
}
