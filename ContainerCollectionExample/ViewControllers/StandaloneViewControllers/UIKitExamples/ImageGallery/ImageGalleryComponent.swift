//  Copyright © 2019 We Are Mobile First.

import ContainerCollection

class ImageGalleryFactory: ComponentFactory {
    func buildComponent(using data: ComponentData) -> ConfigurableComponent? {
        guard validComponent(using: data) else { return nil }
        let controller = ImageGalleryViewController()
        controller.imageGalleryData = data as? ImageGalleryData
        return controller
    }

    func identifyComponent(using data: ComponentData) -> String {
        guard validComponent(using: data) else {
            return ComponentTypes.invalid.rawValue
        }
        return "\(ImageGalleryViewController.self)"
    }

    func validComponent(using data: ComponentData) -> Bool {
        return data is ImageGalleryData
    }
}
