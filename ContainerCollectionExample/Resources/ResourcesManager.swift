//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import UIKit

class ResourcesManager {
    var isRunningUITests: Bool {
        return ProcessInfo.processInfo.environment[Constant.runningUITests] != nil &&
            ProcessInfo.processInfo.environment[Constant.runningUITests] == "1"
    }

    private var previousComponentType: ComponentType?
    private var storedElements: [Element] = []
    private let componentsToRender: [ComponentType]

    enum ComponentType: CaseIterable {
        case horizontalRail, image, imageGallery, mapKit, sceneKit, videoPlayer

        static var defaultComponents: [ComponentType] = [.horizontalRail, .image, .imageGallery, .mapKit, .videoPlayer]
    }

    init(components: [ComponentType] = ComponentType.defaultComponents) {
        componentsToRender = components
    }

    func generateRandomElements(number: Int = 20) -> [Element] {
        guard !isRunningUITests else {
            return generateMockDataForUITests()
        }
        storedElements.removeAll()
        for _ in 0..<number {
            var componentType = componentsToRender.randomElement()!
            if componentType == previousComponentType { componentType = componentsToRender.randomElement()! }
            storedElements.append(generateRandomElement(for: componentType))
            previousComponentType = componentType
        }
        previousComponentType = nil
        return storedElements
    }

    func clearStoredElements() {
        storedElements.removeAll()
    }

    func generateRandomElement(for type: ComponentType) -> Element {
        switch type {
        case .horizontalRail:
            return Element(data: generateRandomHorizontalRail(), factory: HorizontalRailFactory())
        case .image:
            return Element(data: generateRandomImage(), factory: ImageFactory(storyboardName: "Image"))
        case .imageGallery:
            return Element(data: generateRandomGallery(), factory: ImageGalleryFactory())
        case .mapKit:
            return Element(data: generateRandomMap(), factory: MapFactory(storyboardName: "MapKit"))
        case .sceneKit:
            return Element(data: generateRandomScene(), factory: SceneFactory(storyboardName: "SceneKit"))
        case .videoPlayer:
            return Element(data: generateRandomVideo(), factory: VideoPlayerFactory(storyboardName: "VideoPlayer"))
        }
    }
}

extension ResourcesManager {
    func generateRandomHorizontalRail() -> HorizontalRailData {
        NSLog("********** Generating random data for Horizontal Rail component **********")
        var cellsData = [HorizontalRailCellData]()
        let randomInteger = (4...8).randomElement()!
        for _ in 0..<randomInteger {
            let color = (red: CGFloat.random, green: CGFloat.random, blue: CGFloat.random, alpha: CGFloat.random)
            let emoji = Resources.railEmojis.randomElement()!
            let title = Resources.railTitles.randomElement()!
            cellsData.append(HorizontalRailCellData(color: color, emoji: emoji, title: title))
        }
        return HorizontalRailData(cellsData: cellsData)
    }
}

extension ResourcesManager {
    func generateRandomImage() -> ImageData {
        NSLog("********** Generating random data for standalone image component **********")
        let index = Int.random(in: 0..<Resources.imageNames.count)
        let variant: ImageData.Variant = CGFloat.random < 0.75 ? .bottomDetail : .sideDetail
        return ImageData(imageName: Resources.imageNames[index],
                         title: Resources.imageTitles[index],
                         subTitle: Resources.imageSubtitles[index],
                         variant: variant)
    }
}

extension ResourcesManager {
    func generateRandomImageGallery() -> ImageGalleryData {
        NSLog("********** Generating random data for Image Gallery component **********")
        if CGFloat.random < 0.33 {
            return generateRandomGallery()
        } else {
            return generateRandomGrid()
        }
    }

    private func generateRandomGrid() -> ImageGalleryData {
        var imageNames: [String] = []
        let numberOfItems = (3...6).randomElement()!
        for _ in 0..<numberOfItems {
            imageNames.append("0\((1...9).randomElement()!)")
        }
        let images = imageNames.compactMap { UIImage(named: $0) }
        let screenWidth = UIScreen.main.bounds.width
        let aspectRatio_1_1 = CGSize(width: (screenWidth - 40) / 3, height: (screenWidth - 40) / 3)
        return ImageGalleryData(title: "Street Art grid gallery", images: images, itemSize: aspectRatio_1_1)
    }

    private func generateRandomGallery() -> ImageGalleryData {
        var imageNames: [String] = []
        let numberOfItems = (1...3).randomElement()!
        for _ in 0..<numberOfItems {
            imageNames.append("\((10...12).randomElement()!)")
        }
        let images = imageNames.compactMap { UIImage(named: $0) }
        let screenWidth = UIScreen.main.bounds.width
        let aspectRatio_16_9 = CGSize(width: screenWidth - 20, height: (screenWidth - 20) / 16 * 9)
        return ImageGalleryData(title: "Street Art Gallery", images: images, itemSize: aspectRatio_16_9)
    }
}

extension ResourcesManager {
    func generateRandomMap() -> MapViewData {
        NSLog("********** Generating random data for Map component **********")
        let city = Resources.mapCities.randomElement()!
        guard let data = NSDataAsset(name: city)?.data,
            let mapViewData = try? JSONDecoder().decode(MapViewData.self, from: data) else {
            NSLog("---------> Could not decode JSON file for \(city)")
            return MapViewData.fallback
        }
        return mapViewData
    }
}

extension ResourcesManager {
    func generateRandomScene() -> SceneViewData {
        NSLog("********** Generating random data for SceneKit component **********")
        return SceneViewData(sceneFileName: "\(Resources.scenes.randomElement()!).scn")
    }
}

extension ResourcesManager {
    func generateRandomVideo() -> VideoPlayerData {
        NSLog("********** Generating random data for Video Player component **********")
        let index = Int.random(in: 0..<Resources.videoNames.count)
        let name = Resources.videoNames[index]
        let title = Resources.videoTitles[index]
        let subtitle = Resources.videoSubtitles[index]
        let url = Bundle.main.url(forResource: name, withExtension: "mp4")!
        return VideoPlayerData(videoURL: url, title: title, subtitle: subtitle)
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
