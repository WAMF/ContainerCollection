//  Copyright © 2019 We Are Mobile First.

import UIKit

public protocol ContainerCollectionControllerDelegate: NSObjectProtocol {
    func update(controller: UIViewController, data: Any, forIndexPath: IndexPath)
    func createController(data: Any, forIndexPath: IndexPath) -> UIViewController
    func reuseIdentifier(data: Any) -> String
}

public final class ContainerCollectionView: UICollectionView, ContainerLayoutInvalidatable {
    public weak var controllerDelegate: ContainerCollectionControllerDelegate?
    public weak var parentViewController: UIViewController?
    private var cellLayoutInvalid: Bool = false

    /// The CollectionView elements.
    /// Every data update triggers CollectionView reload data.

    public var controllerData: [Any] = [] {
        didSet {
            dataSource = self
            reloadData()
        }
    }

    /// Call invalidateCellLayout to indicate that the collection view cell needs
    /// to requery the layout information.
    /// Will trigger invalidate CollectionView layout if there's non ivalidation in course

    public func invalidateCellLayout() {
        guard !cellLayoutInvalid else { return }
        cellLayoutInvalid = true
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionViewLayout.invalidateLayout()
            strongSelf.cellLayoutInvalid = false
        }
    }
}

extension ContainerCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerData.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = controllerData[indexPath.row]
        guard let identifier = controllerDelegate?.reuseIdentifier(data: data),
            let parent = parentViewController,
            let containerCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ContainerCollectionViewCell else {
            return UICollectionViewCell()
        }

        containerCell.owner = self
        var controller: UIViewController? = containerCell.containerView.embeddedViewController

        if let controller = controller {
            controllerDelegate?.update(controller: controller, data: data, forIndexPath: indexPath)
        } else {

            if let newController = controllerDelegate?.createController(data: data, forIndexPath: indexPath) {
                controllerDelegate?.update(controller: newController, data: data, forIndexPath: indexPath)
                containerCell.addViewController(parent: parent, child: newController)
                controller = newController
            }
        }
        return containerCell
    }
}

extension ContainerCollectionView: ContainerLayoutDelegate {
    public func requestLayout() {
        invalidateCellLayout()
    }
}
