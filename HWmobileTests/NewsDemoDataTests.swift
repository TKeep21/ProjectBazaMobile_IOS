import XCTest
import HWmobileCore
@testable import HWmobile

final class NewsDemoDataTests: XCTestCase {
    func testDemoArticlesAreAvailableWithoutAPIKey() {
        XCTAssertFalse(NewsDemoData.articles.isEmpty)
        XCTAssertTrue(NewsDemoData.articles.allSatisfy { !$0.title.isEmpty })
        XCTAssertTrue(NewsDemoData.articles.allSatisfy { !$0.abstractText.isEmpty })
    }
}
