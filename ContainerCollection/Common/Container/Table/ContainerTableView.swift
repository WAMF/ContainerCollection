//  Copyright © 2019 We Are Mobile First.

import UIKit


/// ContainerTableView is a generic UITableView base class that is used as the main container
/// It manages thre presentation of the data using rows and embeding the *Components* in its cells.
public final class ContainerTableView: UITableView, ContainerLayoutInvalidatable {

    public weak var controllerDelegate: ContainerCollectionControllerDelegate?
    
    /// The parent ViewController used as a host of this TableView.
    public weak var parentViewController: UIViewController?
    
    /// Used internally to allow layout invalidation.
    private var cellLayoutInvalid: Bool = false

    /// Used to provide a view controller as an accessory view for above row content. default is nil. not to be confused with section header
    public var headerController: UIViewController? {
        didSet {
            guard let headerController = headerController else {
                tableHeaderView = nil
                return
            }
            if let parentViewController = parentViewController {
                let headerView = ContainerView()
                headerView.addViewController(parent: parentViewController, child: headerController)
                tableHeaderView = headerView
            }
        }
    }

    /// Used to provide a view controller as an accessory view below content. 
    public var footerController: UIViewController? {
        didSet {
            guard let footerController = footerController else {
                tableFooterView = nil
                return
            }
            if let parentViewController = parentViewController {
                let footerView = ContainerView()
                footerView.addViewController(parent: parentViewController, child: footerController)
                tableFooterView = footerView
            }
        }
    }

    /// The CollectionView elements.
    /// Every data update triggers CollectionView reload data.
    public var controllerData: [Any] = [] {
        didSet {
            dataSource = self
            reloadData()
        }
    }

    /// This will ask UIKit to layout the cells but only if a layout is not already queued.
    public func invalidateCellLayout() {
        guard !cellLayoutInvalid else { return }
        cellLayoutInvalid = true
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.performCellLayout()
            strongSelf.cellLayoutInvalid = false
        }
    }

    /// Used if needs to relayout immediately
    public func forceCellLayout(animated: Bool) {
        performCellLayout(animated: animated)
    }

    /// Used to perform change in the row heights

    public func performCellLayout(animated: Bool = false) {
        let update = {
            self.beginUpdates()
            self.endUpdates()
        }

        if animated {
            update()
        } else {
            UIView.performWithoutAnimation { update() }
        }
    }
}

extension ContainerTableView: ContainerLayoutDelegate {
    public func requestLayout() {
        invalidateCellLayout()
    }

    public func forceLayout(animated: Bool) {
        performCellLayout(animated: animated)
    }
}

extension ContainerTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerData.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = controllerData[indexPath.row]
        guard let identifier = controllerDelegate?.reuseIdentifier(data: data),
            let parent = parentViewController,
            let containerCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ContainerTableViewCell else {
            return UITableViewCell()
        }

        containerCell.owner = self
        let controller: UIViewController? = containerCell.containerView.embeddedViewController
        if let controller = controller {
            controllerDelegate?.update(controller: controller, data: data, forIndexPath: indexPath)
        } else {
            if let newController = controllerDelegate?.createController(data: data, forIndexPath: indexPath) {
                controllerDelegate?.update(controller: newController, data: data, forIndexPath: indexPath)
                containerCell.addViewController(parent: parent, child: newController)
                containerCell.setNeedsLayout()
            }
        }
        return containerCell
    }
}
