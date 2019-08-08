//  Copyright © 2019 We Are Mobile First.

import ContainerCollection

class HorizontalRailFactory: ComponentFactory {
    func buildComponent(using data: ComponentData) -> ConfigurableComponent? {
        guard validComponent(using: data) else { return nil }
        let controller = HorizontalRailViewController()
        controller.horizontalRailData = data as? HorizontalRailData
        return controller
    }

    func identifyComponent(using data: ComponentData) -> String {
        guard validComponent(using: data) else {
            return ComponentTypes.invalid.rawValue
        }
        return "\(HorizontalRailViewController.self)"
    }

    func validComponent(using data: ComponentData) -> Bool {
        return data is HorizontalRailData
    }
}
