//  Copyright © 2019 We Are Mobile First.

import XCTest

class MapViewControllerUITests: BaseUITestCase {
    func testMapViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.map, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.map, type: .staticText, within: application)
        validateExistence(type: .map, within: application)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testMapViewControllerInteractionIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.map, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.map, type: .staticText, within: application)
        validateExistence(type: .map, within: application)
        let initialMap = application.maps.firstMatch.screenshot()
        application.maps.firstMatch.swipeDown()
        application.maps.firstMatch.swipeDown()
        XCTAssertNotEqual(initialMap.pngRepresentation, application.maps.firstMatch.screenshot().pngRepresentation)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
