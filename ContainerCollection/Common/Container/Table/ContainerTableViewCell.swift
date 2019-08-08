//  Copyright © 2019 We Are Mobile First.

import UIKit

public class ContainerTableViewCell: UITableViewCell {
    private weak var retainedController: UIViewController?
    weak var owner: UITableView?

    /// The container view which contains the embedded controllers.
    public lazy var containerView: ContainerView = {
        let containerView = ContainerView()
        contentView.addSubview(containerView)
        containerView.fillSuperview()
        return containerView
    }()

    /// Returns whether it contains an embedded controller or not.
    public var containsController: Bool {
        return retainedController != nil
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = containerView.containsController
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = containerView.containsController
    }

    /// Adds the child controller to the container view.
    public func addViewController(parent: UIViewController, child: UIViewController) {
        if !containsController {
            retainedController = child
            containerView.addViewController(parent: parent, child: child)
            containerView.layoutDelegate = owner as? ContainerLayoutDelegate
        }
    }
}
