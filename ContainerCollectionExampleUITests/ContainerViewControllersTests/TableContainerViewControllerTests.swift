//  Copyright © 2019 We Are Mobile First.

import XCTest

class TableContainerViewControllerTests: BaseUITestCase {
    func testTableContainerViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.containerTableView, type: .staticText, within: application)
        while !application.staticTexts[Constant.MainMenuOption.containerTableView].isHittable {
            application.tables.firstMatch.swipeUp()
        }
        tapElement(identifier: Constant.MainMenuOption.containerTableView, type: .staticText, within: application)
        validateExistence(type: .table, within: application)
        let tableCells = application.tables.firstMatch.descendants(matching: .cell).allElementsBoundByIndex

        validateHorizontalRailLoadedSuccessfully(tableCells[Constant.TableContainerView.horizontalRailIndex])

        validateVideoPlayerLoadedSuccessfully(tableCells[Constant.TableContainerView.videoPlayerIndex])

        validateImageLoadedSuccessfully(tableCells[Constant.TableContainerView.imageIndex])

        while !tableCells[Constant.TableContainerView.imageGalleryIndex].isHittable {
            tableCells[Constant.TableContainerView.videoPlayerIndex].swipeUp()
        }
        validateImageGalleryLoadedSuccessfully(tableCells[Constant.TableContainerView.imageGalleryIndex])

        while !tableCells[Constant.TableContainerView.mapViewIndex].isHittable {
            application.tables.firstMatch.swipeUp()
        }
        validateMapLoadedSuccessfully(tableCells[Constant.TableContainerView.mapViewIndex])

        while !tableCells[Constant.TableContainerView.sceneViewIndex].isHittable {
            tableCells[Constant.TableContainerView.imageGalleryIndex].swipeUp()
        }
        validateSceneLoadedSuccessfully(tableCells[Constant.TableContainerView.sceneViewIndex])
    }

    func testHorizontalRailInteractionIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.containerTableView, type: .staticText, within: application)
        while !application.staticTexts[Constant.MainMenuOption.containerTableView].isHittable {
            application.tables.firstMatch.swipeUp()
        }
        tapElement(identifier: Constant.MainMenuOption.containerTableView, type: .staticText, within: application)
        validateExistence(type: .table, within: application)
        let horizontalRail = application.tables.firstMatch.descendants(matching: .cell).allElementsBoundByIndex[Constant.TableContainerView.horizontalRailIndex]
        let initialTexts = horizontalRail.descendants(matching: .staticText).allElementsBoundByIndex.filter { $0.isHittable }
        horizontalRail.swipeLeft()
        XCTAssertNotEqual(initialTexts, horizontalRail.descendants(matching: .staticText).allElementsBoundByIndex.filter { $0.isHittable })
    }
}

private extension TableContainerViewControllerTests {
    func validateHorizontalRailLoadedSuccessfully(_ candidate: XCUIElement) {
        let textValues = candidate.descendants(matching: .staticText).allElementsBoundByIndex.map { $0.label }
        XCTAssertTrue((4...16).contains(textValues.count))
        XCTAssertTrue(Set(textValues).isSubset(of: Set(Resources.railEmojis + Resources.railTitles)))
    }

    func validateVideoPlayerLoadedSuccessfully(_ candidate: XCUIElement) {
        validateExistence(identifier: Constant.TableContainerView.VideoPlayer.componentIdentifier, type: .other, within: candidate)
        validateExistence(identifier: Constant.TableContainerView.VideoPlayer.playButton, type: .button, within: candidate)
    }

    func validateImageLoadedSuccessfully(_ element: XCUIElement) {
        let textValues = Set(element.descendants(matching: .staticText).allElementsBoundByIndex.map { $0.label })
        XCTAssertEqual(textValues.count, 2)
        XCTAssertTrue(textValues.isSubset(of: Set(Resources.imageTitles + Resources.imageSubtitles)))
    }

    func validateImageGalleryLoadedSuccessfully(_ candidate: XCUIElement) {
        validateElementCount(type: .staticText, equals: 1, within: candidate)
        validateElementCount(type: .other, minValue: 1, maxValue: 3, within: candidate)
    }

    func validateMapLoadedSuccessfully(_ candidate: XCUIElement) {
        validateExistence(type: .map, within: candidate)
    }

    func validateSceneLoadedSuccessfully(_ candidate: XCUIElement) {
        validateExistence(identifier: Constant.SceneKit.camera, type: .other, within: candidate)
        validateExistence(identifier: Constant.SceneKit.directionalField, type: .other, within: candidate)
    }
}
