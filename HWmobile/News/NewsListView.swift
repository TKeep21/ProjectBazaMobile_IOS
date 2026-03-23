import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading, viewModel.articles.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Загрузка новостей…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else if let message = viewModel.errorMessage, viewModel.articles.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 36))
                            .foregroundStyle(.secondary)
                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        if let badge = viewModel.sourceBadgeText {
                            Text(badge)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
                        }
                        ForEach(viewModel.articles) { article in
                            NewsArticleRowView(article: article)
                                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                .listRowSeparator(.visible)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Новости")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.manualRefresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

private struct NewsArticleRowView: View {
    let article: NewsArticleDisplay

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "ru_RU")
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NewsThumbnailView(url: article.imageURL)
            Text(article.title)
                .font(.headline)
            Text(article.abstractText)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .top) {
                Text(article.sourceLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                if let date = article.publishedAt {
                    Text(Self.dateFormatter.string(from: date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct NewsThumbnailView: View {
    let url: URL?
    @StateObject private var loader: NewsImageLoader

    init(url: URL?) {
        self.url = url
        _loader = StateObject(wrappedValue: NewsImageLoader(url: url))
    }

    var body: some View {
        Group {
            switch loader.phase {
            case .idle, .loading:
                loadingPlaceholder
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
            case .failure:
                imagePlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .onAppear {
            loader.loadIfNeeded()
        }
    }

    private var loadingPlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.12)
            ProgressView()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }

    private var imagePlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.12)
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }
}

#Preview {
    NewsListView()
}
