//  Copyright © 2019 We Are Mobile First.

import XCTest

class ImageGalleryViewControllerUITests: BaseUITestCase {
    func testImageGalleryViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.imageGallery, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.imageGallery, type: .staticText, within: application)
        validateExistence(type: .collectionView, within: application)
        validateElementCount(type: .staticText, equals: 1, within: application)
        validateElementCount(type: .cell, minValue: 1, maxValue: 3, within: application)
        validateElementCount(type: .image, minValue: 1, maxValue: 3, within: application)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testImageGalleryViewControllerInterationIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.imageGallery, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.imageGallery, type: .staticText, within: application)
        validateExistence(type: .collectionView, within: application)
        if application.collectionViews.firstMatch.descendants(matching: .cell).count > 1 {
            changeDeviceOrientation(to: .landscapeLeft)
            let initialCells = application.collectionViews.descendants(matching: .cell)
            application.collectionViews.firstMatch.swipeUp()
            XCTAssertNotEqual(initialCells, application.collectionViews.firstMatch.descendants(matching: .cell))
            changeDeviceOrientation(to: .portrait)
        }
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
