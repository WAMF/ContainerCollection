//  Copyright © 2019 We Are Mobile First.

import UIKit

public protocol ContainerLayoutDelegate {
    
    /// Call to request the view to layout
    func requestLayout()
    
}

public protocol ContainerLayoutInvalidatable {

    /// Invalidates the current layout and triggers a layout update.
    func invalidateCellLayout()
    
}

extension UIView {
    
    /// Used to notify the parent container that its child is about to change the content size
    /// thus it needs to invalidate its layout in order to its conainer view calculate its new frame
    public func invalidateContainerLayout() {
        guard let superview = self.superview else { return }
        if let containerCell = superview as? ContainerLayoutInvalidatable {
            containerCell.invalidateCellLayout()
            return
        } else {
            superview.invalidateContainerLayout()
        }
    }
    
}

public class ContainerView: UIView {

    /// The parent view controller of the recipient
    
    public private(set) weak var parentViewController: UIViewController?
    
    /// The embedded view controller of the recipient

    public private(set) weak var embeddedViewController: UIViewController?

    /// The layout delegate used to allow/inform of layout changes.

    public var layoutDelegate: ContainerLayoutDelegate?

    /// Returns whether it contains an embedded controller or not.

    public var containsController: Bool {
        return embeddedViewController != nil
    }
    
    /// Adds a child controller to the parent

    public func addViewController(parent: UIViewController, child: UIViewController) {
        clipsToBounds = true
        if containsController {
            removeViewController()
        }
        if parentViewController != parent, embeddedViewController != child {
            parent.addChild(child)
            parentViewController = parent
            embeddedViewController = child
            addControllerView(child: child)
        }
    }

    /// Adds the child controller's view as a subview and fill super view using autolayout

    private func addControllerView(child: UIViewController) {
        if child.view.superview != self {
            addSubview(child.view)
            child.view.fillSuperview()
            child.didMove(toParent: parentViewController)
        }
    }

    public func addControllerViewIfNeeded(child: UIViewController) {
        guard let parentViewController = parentViewController, parentViewController.isViewLoaded else { return }
        addControllerView(child: child)
    }
    
    /// To remove a child view controller, removing the parent-child relationship between the view controllers

    public func removeViewController() {
        embeddedViewController?.willMove(toParent: nil)
        embeddedViewController?.view.removeFromSuperview()
        embeddedViewController?.removeFromParent()
        parentViewController = nil
        embeddedViewController = nil
    }

    deinit {
        removeViewController()
    }
    
}
