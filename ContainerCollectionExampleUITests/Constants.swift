//  Copyright © 2019 We Are Mobile First.

enum Constant {
    static let backButton = "Back"

    static let runningUITests = "RUNNING_UI_TESTS"

    enum MainMenuOption {
        static let horizontalRail = "Horizontal rail"
        static let image = "Image with title"
        static let imageGallery = "Image gallery"
        static let map = "Map"
        static let sceneView = "Scene: spinning geometric form"
        static let videoPlayer = "Video player"
        static let containerTableView = "Container table view"
    }

    enum SceneKit {
        static let camera = "Camera"
        static let directionalField = "directional"
    }

    enum VideoPlayer {
        static let closeFullScreenButton = "Done"
        static let fullScreenButton = "Full Screen"
        static let playOrPauseButton = "Play/Pause"
        static let sizeToFillButton = "Zoom"
        static let timeElapsedText = "Time Elapsed"
        static let timeRemainingText = "Time Remaining"
    }

    enum TableContainerView {
        static let horizontalRailIndex = 0
        static let videoPlayerIndex = 1
        static let imageIndex = 2
        static let imageGalleryIndex = 3
        static let mapViewIndex = 4
        static let sceneViewIndex = 5

        enum VideoPlayer {
            static let componentIdentifier = "Video"
            static let playButton = "Play"
        }
    }
}
