//  Copyright © 2019 We Are Mobile First.

import ContainerCollection

extension ResourcesManager {
    func generateMockDataForUITests() -> [Element] {
        let horizontalRail = generateRandomElement(for: .horizontalRail)
        let image = generateRandomElement(for: .image)
        let imageGallery = generateRandomElement(for: .imageGallery)
        let map = generateRandomElement(for: .mapKit)
        let scene = generateRandomElement(for: .sceneKit)
        let videoPlayer = generateRandomElement(for: .videoPlayer)
        return [horizontalRail, videoPlayer, image, imageGallery, map, scene]
    }
}
