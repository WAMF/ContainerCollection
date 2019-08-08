//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import UIKit

class TableContainerViewController: UIViewController {
    @IBOutlet private var containerTableView: ContainerTableView!

    var elements: [Element] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerTableView()
        registerIdentifiers(from: elements)
        containerTableView.controllerData = elements
    }

    deinit {
        elements.removeAll()
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerTableView.requestLayout()
    }
}

extension TableContainerViewController: ContainerCollectionControllerDelegate {
    func update(controller: UIViewController, data: Any, forIndexPath: IndexPath) {
        guard let element = data as? Element, let controller = controller as? ConfigurableComponent else { return }
        if let fallbackController = controller as? FallbackViewController {
            fallbackController.configure(with: reuseIdentifier(data: data))
        } else {
            controller.configure(with: element.data)
        }
    }

    func createController(data: Any, forIndexPath: IndexPath) -> UIViewController {
        guard let element = data as? Element,
            let controller = element.factory.buildComponent(using: element.data) as? UIViewController else {
            return FallbackFactory().buildComponent(using: reuseIdentifier(data: data)) as! UIViewController
        }
        return controller
    }

    func reuseIdentifier(data: Any) -> String {
        guard let element = data as? Element else { return "unsupported" }
        return element.factory.identifyComponent(using: element.data)
    }
}

private extension TableContainerViewController {
    func setupContainerTableView() {
        containerTableView.controllerDelegate = self
        containerTableView.parentViewController = self
    }

    func registerIdentifiers(from elements: [Element]) {
        for element in elements {
            let id = element.factory.identifyComponent(using: element.data)
            containerTableView?.register(ContainerTableViewCell.self, forCellReuseIdentifier: id)
        }
    }
}
