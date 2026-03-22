import Combine
import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [NewsArticleDisplay] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private let service = NYTimesNewsService()
    private var refreshLoopTask: _Concurrency.Task<Void, Never>?
    private var didFireBonusPost = false

    deinit {
        refreshLoopTask?.cancel()
    }

    func onAppear() {
        startPeriodicRefreshIfNeeded()
        fireBonusPostOnce()
    }

    func onDisappear() {
        refreshLoopTask?.cancel()
        refreshLoopTask = nil
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
                await self.loadNews()
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

    private func loadNews() async {
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
            errorMessage = NewsServiceError.missingAPIKey.errorDescription
            return
        }
        do {
            let next = try await service.fetchHomeTopStories(apiKey: key)
            articles = next
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
}
