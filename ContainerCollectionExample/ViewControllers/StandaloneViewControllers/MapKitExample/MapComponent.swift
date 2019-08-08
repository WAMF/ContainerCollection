//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import Foundation

class MapFactory: ComponentFactory {
    private let storyboardName: String

    init(storyboardName: String) {
        self.storyboardName = storyboardName
    }

    func buildComponent(using data: ComponentData) -> ConfigurableComponent? {
        guard validComponent(using: data) else { return nil }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() as? MapViewController {
            controller.mapViewData = data as? MapViewData
            return controller
        }
        return nil
    }

    func identifyComponent(using data: ComponentData) -> String {
        guard validComponent(using: data) else {
            return ComponentTypes.invalid.rawValue
        }
        return "\(MapViewController.self).\(storyboardName)"
    }

    func validComponent(using data: ComponentData) -> Bool {
        return data is MapViewData
    }
}
