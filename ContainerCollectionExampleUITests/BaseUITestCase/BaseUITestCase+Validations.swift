//  Copyright © 2019 We Are Mobile First.

import XCTest

extension BaseUITestCase {
    func validateExistence(identifier: String? = nil,
                           type: XCUIElement.ElementType,
                           within container: XCUIElement) {
        guard let identifier = identifier else {
            validateElementCount(type: type, minValue: 1, within: container)
            return
        }

        let element = container.getElement(identifier, type: type)
        validateElementExists(element, "Element with type \(String(describing: type)) with identifier \(identifier) does not exist")
    }

    func validateNonExistence(identifier: String?,
                              type: XCUIElement.ElementType,
                              within container: XCUIElement) {
        guard let identifier = identifier else {
            validateElementCount(type: type, equals: 0, within: container)
            return
        }

        let element = container.getElement(identifier, type: type)
        validateElementNotExist(element, "Element with type \(String(describing: type)) with identifier \(identifier) exists when not expected")
    }

    func validateElementCount(type: XCUIElement.ElementType, equals value: Int, within container: XCUIElement) {
        validateElementCount(type: type, minValue: value, maxValue: value, within: container)
    }

    func validateElementCount(type: XCUIElement.ElementType, minValue: Int = Int.min, maxValue: Int = Int.max, within container: XCUIElement) {
        XCTAssertGreaterThanOrEqual(maxValue, minValue, "Invalid parameters: \(minValue) > \(maxValue)!")
        waitForElementToAppear(type: type, within: container, timeout: 5)
        let count = container.descendants(matching: type).count
        XCTAssertTrue((minValue...maxValue).contains(count))
    }
}

private extension BaseUITestCase {
    func validateElementExists(_ element: XCUIElement, _ failureOutput: String) {
        waitForElementToAppear(element: element)
        XCTAssertTrue(element.exists, failureOutput)
    }

    func validateElementNotExist(_ element: XCUIElement, _ failureOutput: String) {
        waitForElementToDisappear(element: element)
        XCTAssertFalse(element.exists, failureOutput)
    }
}
