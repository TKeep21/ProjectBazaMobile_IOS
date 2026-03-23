import Combine
import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
private typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
private typealias PlatformImage = NSImage
#endif

@MainActor
final class NewsImageLoader: ObservableObject {
    enum Phase {
        case idle
        case loading
        case success(Image)
        case failure
    }

    @Published private(set) var phase: Phase = .idle

    private let url: URL?
    private let cacheStore: NewsImageCacheStore
    private var task: _Concurrency.Task<Void, Never>?

    init(url: URL?, cacheStore: NewsImageCacheStore = NewsImageCacheStore()) {
        self.url = url
        self.cacheStore = cacheStore
    }

    deinit {
        task?.cancel()
    }

    func loadIfNeeded() {
        guard case .idle = phase else { return }
        guard let url else {
            phase = .failure
            return
        }
        phase = .loading
        task = _Concurrency.Task { [weak self] in
            guard let self else { return }
            do {
                let data = try await self.cacheStore.fetchImageData(url: url)
                guard let image = PlatformImage(data: data) else {
                    self.phase = .failure
                    return
                }
                #if canImport(UIKit)
                self.phase = .success(Image(uiImage: image))
                #elseif canImport(AppKit)
                self.phase = .success(Image(nsImage: image))
                #endif
            } catch {
                self.phase = .failure
            }
        }
    }
}
