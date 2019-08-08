//  Copyright © 2019 We Are Mobile First.

import UIKit

public struct FallbackData {
    var text: String
}

public class FallbackFactory: ComponentFactory {
    public func buildComponent(using data: ComponentData) -> ConfigurableComponent? {
        let storyboard = UIStoryboard(name: "FallbackViewController", bundle: Bundle(for: FallbackFactory.self))
        if let controller = storyboard.instantiateInitialViewController() as? FallbackViewController {
            let identifier = data as? String ?? ""
            controller.fallbackData = FallbackData(text: "Unable to render component \(identifier)")
            return controller
        }
        return nil
    }

    public func identifyComponent(using data: ComponentData) -> String {
        return "\(FallbackViewController.self)"
    }

    public func validComponent(using data: ComponentData) -> Bool {
        return true
    }

    public init() {}
}

/// This is a default render component to be rendered while the component isn't supported yet.
public class FallbackViewController: UIViewController {
    @IBOutlet var label: UILabel?

    public var fallbackData: FallbackData? {
        didSet { refreshView() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
    }

    public func refreshView() {
        guard isViewLoaded, let data = fallbackData else { return }
        label?.text = data.text
    }
}

extension FallbackViewController: ConfigurableComponent {
    public func configure(with data: ComponentData?) {
        let identifier = data as? String ?? ""
        fallbackData = FallbackData(text: "Unable to render \(identifier)")
    }
}

extension String: ComponentData {}
