//  Copyright © 2019 We Are Mobile First.

import XCTest

class SceneViewControllerTests: BaseUITestCase {
    func testSceneViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.sceneView, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.sceneView, type: .staticText, within: application)
        validateExistence(identifier: Constant.SceneKit.camera, type: .other, within: application)
        validateExistence(identifier: Constant.SceneKit.directionalField, type: .other, within: application)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
