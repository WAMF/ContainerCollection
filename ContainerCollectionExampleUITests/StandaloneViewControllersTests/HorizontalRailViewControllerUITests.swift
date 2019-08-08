//  Copyright © 2019 We Are Mobile First.

import XCTest

class HorizontalRailViewUITests: BaseUITestCase {
    func testHorizontalRailViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.horizontalRail, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.horizontalRail, type: .staticText, within: application)
        validateExistence(type: .collectionView, within: application)
        validateElementCount(type: .cell, minValue: 2, maxValue: 8, within: application)
        validateElementCount(type: .staticText, minValue: 4, maxValue: 16, within: application)
        let textValues = Set(application.collectionViews.firstMatch.descendants(matching: .staticText).allElementsBoundByIndex.map { $0.label })
        XCTAssertTrue(textValues.isSubset(of: Set(Resources.railEmojis + Resources.railTitles)))
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testHorizontalRailViewControllerInteractionIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.horizontalRail, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.horizontalRail, type: .staticText, within: application)
        validateExistence(type: .collectionView, within: application)
        let initialCells = application.collectionViews.firstMatch.descendants(matching: .cell).allElementsBoundByIndex.filter { $0.isHittable }
        application.collectionViews.firstMatch.swipeLeft()
        XCTAssertNotEqual(initialCells, application.collectionViews.firstMatch.descendants(matching: .cell).allElementsBoundByIndex.filter { $0.isHittable })
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
