//  Copyright © 2019 We Are Mobile First.

import UIKit

public class ContainerCollectionViewCell: UICollectionViewCell {
    private weak var retainedController: UIViewController?
    weak var owner: UICollectionView?
    
    /// The container view which contains the embedded controllers.

    public lazy var containerView: ContainerView = {
        let containerView = ContainerView()
        self.contentView.addSubview(containerView)
        containerView.fillSuperview()
        return containerView
    }()

    public lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    /// Returns whether it contains an embedded controller or not.

    public var containsController: Bool {
        return retainedController != nil
    }
    
    /// Adds the child controller to the container view.

    public func addViewController(parent: UIViewController, child: UIViewController) {
        if !containsController {
            retainedController = child
            containerView.addViewController(parent: parent, child: child)
            containerView.layoutDelegate = owner as? ContainerLayoutDelegate
        }
    }

    public func idealWidth() -> CGFloat {
        return owner?.bounds.size.width ?? UIScreen.main.bounds.width
    }

    
    /// Returns the optimal size of the view based on its current constraints.
    
    override public func systemLayoutSizeFitting(_ targetSize: CGSize,
                                                 withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                                 verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = targetSize.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 10))
    }
}
