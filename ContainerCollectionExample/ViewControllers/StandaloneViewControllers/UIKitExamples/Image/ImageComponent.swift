//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import Foundation

class ImageFactory: ComponentFactory {
    private let storyboardName: String

    init(storyboardName: String) {
        self.storyboardName = storyboardName
    }

    func buildComponent(using data: ComponentData) -> ConfigurableComponent? {
        guard validComponent(using: data) else { return nil }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let variant: ImageData.Variant = (data as? ImageData)?.variant ?? .bottomDetail
        if let controller = storyboard.instantiateViewController(withIdentifier: variant.rawValue) as? ImageViewController {
            controller.imageData = data as? ImageData
            return controller
        }
        return nil
    }

    func identifyComponent(using data: ComponentData) -> String {
        guard validComponent(using: data) else {
            return ComponentTypes.invalid.rawValue
        }
        let variant: ImageData.Variant = (data as? ImageData)?.variant ?? .bottomDetail
        return "\(ImageViewController.self).\(storyboardName).\(variant.rawValue)"
    }

    func validComponent(using data: ComponentData) -> Bool {
        return data is ImageData
    }
}
