import XCTest
import HWmobileCore
@testable import HWmobile

final class NewsDTOMapperTests: XCTestCase {
    func testDisplayArticlesMapsValidTopStoriesPayload() throws {
        let data = Data(Self.validPayload.utf8)

        let articles = try NewsDTOMapper.displayArticles(from: data)

        XCTAssertEqual(articles.count, 1)
        XCTAssertEqual(articles[0].id, "nyt://article/test-1")
        XCTAssertEqual(articles[0].title, "SwiftUI App Gets Tests")
        XCTAssertEqual(articles[0].abstractText, "Core logic is covered by unit tests.")
        XCTAssertEqual(articles[0].sourceLabel, "The New York Times — Technology, Mobile")
        XCTAssertEqual(articles[0].imageURL, URL(string: "https://example.com/image.jpg"))
        XCTAssertNotNil(articles[0].publishedAt)
    }

    func testDisplayArticlesRejectsNonOkStatus() {
        let data = Data(#"{"status":"ERROR","results":[]}"#.utf8)

        XCTAssertThrowsError(try NewsDTOMapper.displayArticles(from: data)) { error in
            XCTAssertEqual(error as? NewsServiceError, .invalidPayload)
        }
    }

    private static let validPayload = """
    {
      "status": "OK",
      "results": [
        {
          "section": "Technology",
          "subsection": "Mobile",
          "title": "SwiftUI App Gets Tests",
          "abstract": "Core logic is covered by unit tests.",
          "uri": "nyt://article/test-1",
          "published_date": "2026-06-15T09:30:00-04:00",
          "multimedia": [
            {
              "type": "image",
              "url": "https://example.com/image.jpg"
            }
          ]
        }
      ]
    }
    """
}
