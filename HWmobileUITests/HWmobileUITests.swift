import XCTest

final class HWmobileUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCreateTaskHappyPath() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestMode", "1"]
        app.launch()

        openTasksTab(in: app)
        app.buttons["addTaskButton"].tap()

        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("UI тест задача")

        let detailsField = app.textFields["taskDetailsField"]
        detailsField.tap()
        detailsField.typeText("создана из UI теста")

        app.buttons["saveTaskButton"].tap()

        XCTAssertTrue(app.staticTexts["UI тест задача"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.descendants(matching: .any)["taskAnalyticsView"].waitForExistence(timeout: 5))
    }

    func testTasksScreenSnapshot() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestMode", "1"]
        app.launch()

        openTasksTab(in: app)
        XCTAssertTrue(app.navigationBars["Задачи"].waitForExistence(timeout: 5))

        let screenshot = app.screenshot()
        XCTAssertGreaterThan(screenshot.pngRepresentation.count, 1_000)

        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Tasks screen snapshot"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testCreateNoteHappyPath() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestMode", "1"]
        app.launch()

        openNotesTab(in: app)
        app.buttons["addNoteButton"].tap()

        let titleField = app.textFields["noteTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("UI заметка")

        app.buttons["saveNoteButton"].tap()

        XCTAssertTrue(app.staticTexts["UI заметка"].waitForExistence(timeout: 5))
    }

    private func openTasksTab(in app: XCUIApplication) {
        let tasksTab = app.tabBars.buttons["Задачи"]
        XCTAssertTrue(tasksTab.waitForExistence(timeout: 5))
        tasksTab.tap()
    }

    private func openNotesTab(in app: XCUIApplication) {
        let notesTab = app.tabBars.buttons["Заметки"]
        XCTAssertTrue(notesTab.waitForExistence(timeout: 5))
        notesTab.tap()
    }
}
