//  Copyright © 2019 We Are Mobile First.

import XCTest

class ImageViewControllerUITests: BaseUITestCase {
    func testImageViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.image, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.image, type: .staticText, within: application)
        validateExistence(type: .image, within: application)
        validateElementCount(type: .staticText, equals: 2, within: application)
        let textValues = Set(application.descendants(matching: .staticText).allElementsBoundByIndex.map { $0.label })
        XCTAssertTrue(textValues.isSubset(of: Set(Resources.imageTitles + Resources.imageSubtitles)))
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
