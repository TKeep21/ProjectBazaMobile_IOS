import Foundation

struct NewsArticleDisplay: Identifiable, Equatable, Codable {
    let id: String
    let title: String
    let abstractText: String
    let sourceLabel: String
    let publishedAt: Date?
    let imageURL: URL?
}

enum NewsDataSource {
    case network
    case cache
}

private struct TopStoriesResponseDTO: Decodable {
    let status: String
    let results: [TopStoryResultDTO]
}

private struct TopStoryResultDTO: Decodable {
    let section: String
    let subsection: String?
    let title: String
    let abstract: String
    let uri: String
    let publishedDate: String
    let multimedia: [TopStoryMultimediaDTO]?

    enum CodingKeys: String, CodingKey {
        case section
        case subsection
        case title
        case abstract
        case uri
        case publishedDate = "published_date"
        case multimedia
    }
}

private struct TopStoryMultimediaDTO: Decodable {
    let type: String
    let url: String
}

enum NewsDTOMapper {
    private static let isoParser: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let isoParserNoFraction: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static func displayArticles(from data: Data) throws -> [NewsArticleDisplay] {
        let decoder = JSONDecoder()
        let dto = try decoder.decode(TopStoriesResponseDTO.self, from: data)
        guard dto.status == "OK" else {
            throw NewsServiceError.invalidPayload
        }
        return dto.results.compactMap { mapResult($0) }
    }

    private static func mapResult(_ dto: TopStoryResultDTO) -> NewsArticleDisplay? {
        let trimmedUri = dto.uri.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUri.isEmpty else {
            return nil
        }
        let source = makeSourceLabel(section: dto.section, subsection: dto.subsection ?? "")
        let published = parseDate(dto.publishedDate)
        let imageURL = pickImageURL(from: dto.multimedia)
        return NewsArticleDisplay(
            id: trimmedUri,
            title: dto.title,
            abstractText: dto.abstract,
            sourceLabel: source,
            publishedAt: published,
            imageURL: imageURL
        )
    }

    private static func makeSourceLabel(section: String, subsection: String) -> String {
        let sec = section.trimmingCharacters(in: .whitespacesAndNewlines)
        let sub = subsection.trimmingCharacters(in: .whitespacesAndNewlines)
        if sec.isEmpty, sub.isEmpty {
            return "The New York Times"
        }
        if sub.isEmpty {
            return "The New York Times — \(sec)"
        }
        if sec.isEmpty {
            return "The New York Times — \(sub)"
        }
        return "The New York Times — \(sec), \(sub)"
    }

    private static func parseDate(_ raw: String) -> Date? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return nil
        }
        if let d = isoParser.date(from: trimmed) {
            return d
        }
        return isoParserNoFraction.date(from: trimmed)
    }

    private static func pickImageURL(from items: [TopStoryMultimediaDTO]?) -> URL? {
        guard let items else {
            return nil
        }
        for item in items where item.type == "image" {
            let trimmed = item.url.trimmingCharacters(in: .whitespacesAndNewlines)
            if let url = URL(string: trimmed) {
                return url
            }
        }
        return nil
    }
}

enum NewsServiceError: LocalizedError {
    case invalidPayload
    case missingAPIKey
    case badStatusCode(Int)
    case missingCache

    var errorDescription: String? {
        switch self {
        case .invalidPayload:
            return "Не удалось разобрать ответ сервера новостей."
        case .missingAPIKey:
            return "Не задан ключ NY Times API. Укажите NYTIMES_API_KEY в схеме или заполните embeddedKey в NYTimesAPIConfig."
        case .badStatusCode(let code):
            return "Ошибка сети (код \(code))."
        case .missingCache:
            return "Локальный кэш новостей пуст."
        }
    }
}
