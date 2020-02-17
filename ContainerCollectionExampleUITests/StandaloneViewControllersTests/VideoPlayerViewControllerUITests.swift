//  Copyright © 2019 We Are Mobile First.

import XCTest

class VideoPlayerViewControllerUITests: BaseUITestCase {
    func testVideoPlayerViewControllerLoadsSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        validateExistence(type: .slider, within: application)
        validateExistence(identifier: Constant.VideoPlayer.timeElapsedText, type: .staticText, within: application)
        validateExistence(identifier: Constant.VideoPlayer.timeRemainingText, type: .staticText, within: application)
        validateExistence(identifier: Constant.VideoPlayer.playOrPauseButton, type: .button, within: application)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testVideoPlayerViewControllerPlaysContentSuccessfully() {
        validateExistence(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        validateExistence(type: .slider, within: application)
        let sliderValue = Double(HHMMSS: (application.sliders.firstMatch.value as! String).split(separator: ":").map { String($0) })
        sleep(2)
        let newSliderValue = Double(HHMMSS: (application.sliders.firstMatch.value as! String).split(separator: ":").map { String($0) })
        XCTAssertTrue(newSliderValue > sliderValue)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testVideoPlayerPlayPauseButtonIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        validateExistence(type: .slider, within: application)
        validateExistence(identifier: Constant.VideoPlayer.playOrPauseButton, type: .button, within: application)
        tapElement(identifier: Constant.VideoPlayer.playOrPauseButton, type: .button, within: application)
        let sliderValue = Double(HHMMSS: (application.sliders.firstMatch.value as! String).split(separator: ":").map { String($0) })
        sleep(2)
        let newSliderValue = Double(HHMMSS: (application.sliders.firstMatch.value as! String).split(separator: ":").map { String($0) })
        XCTAssertEqual(newSliderValue, sliderValue)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testVideoPlayerSliderInteractionEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        validateExistence(type: .slider, within: application)
        validateExistence(identifier: Constant.VideoPlayer.timeRemainingText, type: .staticText, within: application)
        sleep(6)
        let timeRemainingValue = Double(HHMMSS: (application.staticTexts[Constant.VideoPlayer.timeRemainingText].value as! String).split(separator: ":").map { String($0) })
        application.sliders.firstMatch.swipeLeft()
        let newTimeRemainingValue = Double(HHMMSS: (application.staticTexts[Constant.VideoPlayer.timeRemainingText].value as! String).split(separator: ":").map { String($0) })
        XCTAssertTrue(newTimeRemainingValue > timeRemainingValue)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }

    func testVideoPlayerFullScreenInteractionIsEnabled() {
        validateExistence(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        tapElement(identifier: Constant.MainMenuOption.videoPlayer, type: .staticText, within: application)
        validateExistence(type: .slider, within: application)
        validateExistence(identifier: Constant.VideoPlayer.fullScreenButton, type: .button, within: application)
        tapElement(identifier: Constant.VideoPlayer.fullScreenButton, type: .button, within: application)
        validateExistence(identifier: Constant.VideoPlayer.closeFullScreenButton, type: .button, within: application)
        validateExistence(identifier: Constant.VideoPlayer.sizeToFillButton, type: .button, within: application)
        validateNonExistence(identifier: Constant.backButton, type: .button, within: application)
        tapElement(identifier: Constant.VideoPlayer.closeFullScreenButton, type: .button, within: application)
        validateNonExistence(identifier: Constant.VideoPlayer.closeFullScreenButton, type: .button, within: application)
        validateNonExistence(identifier: Constant.VideoPlayer.sizeToFillButton, type: .button, within: application)
        XCTAssertTrue(application.buttons[Constant.backButton].isHittable)
        tapElement(identifier: Constant.backButton, type: .button, within: application)
        validateExistence(type: .table, within: application)
    }
}
