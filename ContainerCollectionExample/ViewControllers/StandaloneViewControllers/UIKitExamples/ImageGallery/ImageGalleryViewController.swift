//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import UIKit

struct ImageGalleryData: ComponentData {
    let title: String
    let images: [UIImage?]
    let itemSize: CGSize
}

class ImageGalleryViewController: UIViewController {
    private enum Constant {
        static let margin: CGFloat = 10
    }

    var imageGalleryData: ImageGalleryData? {
        didSet { refreshView() }
    }

    private var images: [UIImage] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var labelHeightConstraint: NSLayoutConstraint = {
        let constraint = titleLabel.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = UILayoutPriority(1000)
        titleLabel.addConstraint(constraint)
        constraint.isActive = true
        return constraint
    }()

    private lazy var collectionViewHeightConstraint: NSLayoutConstraint = {
        let constraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = UILayoutPriority(999)
        collectionView.addConstraint(constraint)
        constraint.isActive = true
        return constraint
    }()

    deinit {
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCells()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        edgesForExtendedLayout = []
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        setupConstraints()
    }

    private func setupConstraints() {
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constant.margin)
        bottomConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.margin),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.margin),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constant.margin),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.margin),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.margin),
            bottomConstraint
        ])
    }

    private func registerCells() {
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseIdentifier)
    }

    private func refreshView() {
        guard isViewLoaded, let data = imageGalleryData else { return }
        titleLabel.text = data.title
        titleLabel.sizeToFit()
        labelHeightConstraint.constant = titleLabel.bounds.size.height
        images = data.images.compactMap { $0 }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = data.itemSize
            layout.invalidateLayout()
        }
        collectionView.reloadData()
        collectionView.isScrollEnabled = !collectionViewShouldDefineItsHeight()
        updateLayout()
    }
}

extension ImageGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath) as? GalleryCell else { fatalError() }
        cell.configure(image: images[indexPath.item])
        return cell
    }
}

extension ImageGalleryViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let imageGalleryData = data as? ImageGalleryData else { return }
        self.imageGalleryData = imageGalleryData
    }
}

/// In order to use UICollectionView's in ContainerCollection, the collection view (or the view controller containing it)
/// must be able to define it's own size. The following extension contains the functions necessary to achieve this
/// in on conjunction with the 'collectionViewHeightConstraint' defined in the main class.

extension ImageGalleryViewController {
    func collectionViewShouldDefineItsHeight() -> Bool {
        return (parent as? TableContainerViewController) != nil
    }

    func updateLayout() {
        guard collectionViewShouldDefineItsHeight(),
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            /// If we don't have a parent, we are using this view controller as a standalone view controller, and
            /// thus we may disable the height constraints.
            collectionViewHeightConstraint.isActive = false
            labelHeightConstraint.isActive = false
            return
        }

        let itemsPerRow: CGFloat
        let additionalHeightPerRow: CGFloat
        if imageGalleryData?.itemSize == CGSize(width: UIScreen.main.bounds.width - 20, height: (UIScreen.main.bounds.width - 20) / 16 * 9) {
            itemsPerRow = 1.0
            additionalHeightPerRow = 20 / 16 * 9
        } else {
            itemsPerRow = 3.0
            additionalHeightPerRow = 40 / 3
        }
        let numberOfRows = (CGFloat(images.count) / itemsPerRow).rounded(.up)
        collectionViewHeightConstraint.constant = (layout.itemSize.height + additionalHeightPerRow) * numberOfRows
        collectionViewHeightConstraint.isActive = true
    }
}
