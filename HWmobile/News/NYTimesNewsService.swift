import Foundation

actor NYTimesNewsService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchHomeTopStories(apiKey: String) async throws -> [NewsArticleDisplay] {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            throw NewsServiceError.missingAPIKey
        }
        var components = URLComponents(string: "https://api.nytimes.com/svc/topstories/v2/home.json")
        components?.queryItems = [URLQueryItem(name: "api-key", value: trimmedKey)]
        guard let url = components?.url else {
            throw NewsServiceError.invalidPayload
        }
        let (data, response) = try await session.data(from: url)
        if let http = response as? HTTPURLResponse {
            guard (200 ... 299).contains(http.statusCode) else {
                throw NewsServiceError.badStatusCode(http.statusCode)
            }
        }
        return try NewsDTOMapper.displayArticles(from: data)
    }
}
