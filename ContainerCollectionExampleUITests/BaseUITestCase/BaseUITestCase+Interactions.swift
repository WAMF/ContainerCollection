//  Copyright © 2019 We Are Mobile First.

import XCTest

extension BaseUITestCase {
    func tapElement(identifier: String?,
                    type: XCUIElement.ElementType,
                    within container: XCUIElement) {
        guard let identifier = identifier else {
            tap(container.descendants(matching: type).firstMatch)
            return
        }
        let element = container.getElement(identifier, type: type)
        tap(element)
    }

    func waitForElementToAppear(element: XCUIElement, timeout: Double = 20) {
        waitForElementsToAppear(elements: [element], timeout: timeout)
    }

    func waitForElementsToAppear(elements: [XCUIElement], timeout: Double = 20) {
        let exists = NSPredicate(format: "exists == 1")
        let expectations = elements.map { expectation(for: exists, evaluatedWith: $0, handler: nil) }
        XCTWaiter().wait(for: expectations, timeout: timeout)
    }

    func waitForElementToAppear(type: XCUIElement.ElementType, within container: XCUIElement, timeout: Double = 20) {
        let exists = NSPredicate(format: "count > 0")
        let typeToEvaluate = container.descendants(matching: type)
        let existenceExpectation = expectation(for: exists, evaluatedWith: typeToEvaluate, handler: nil)
        XCTWaiter().wait(for: [existenceExpectation], timeout: timeout)
    }

    func waitForElementToDisappear(element: XCUIElement, timeout: Double = 20) {
        waitForElementsToDisappear(elements: [element], timeout: timeout)
    }

    func waitForElementsToDisappear(elements: [XCUIElement], timeout: Double = 20) {
        let notExist = NSPredicate(format: "exists == 0")
        let expectations = elements.map { expectation(for: notExist, evaluatedWith: $0, handler: nil) }
        XCTWaiter().wait(for: expectations, timeout: timeout)
    }

    func changeDeviceOrientation(to newOrientation: UIDeviceOrientation) {
        XCUIDevice.shared.orientation = newOrientation
    }
}

private extension BaseUITestCase {
    func tap(_ element: XCUIElement) {
        waitForElementToAppear(element: element)
        element.tap()
    }
}
