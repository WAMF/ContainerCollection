//  Copyright © 2019 We Are Mobile First.

import XCTest

class BaseUITestCase: XCTestCase {
    let application = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        launchApp()
    }

    override func tearDown() {
        application.terminate()
    }

    func launchApp() {
        application.launchEnvironment[Constant.runningUITests] = "1"
        application.launch()
    }
}

extension XCUIElement {
    func getElement(_ identifier: String? = nil, type: XCUIElement.ElementType) -> XCUIElement {
        guard let identifier = identifier else {
            return descendants(matching: type).firstMatch
        }
        return descendants(matching: type)[identifier]
    }
}
