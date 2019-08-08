//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import UIKit

struct HorizontalRailData: ComponentData {
    let cellsData: [HorizontalRailCellData]
}

final class HorizontalRailViewController: UIViewController {
    var horizontalRailData: HorizontalRailData? {
        didSet { refreshView() }
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 200, height: 220)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCells()
    }

    deinit {
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        edgesForExtendedLayout = []
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 240.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint
        ])
    }

    private func registerCells() {
        collectionView.register(HorizontalRailCell.self, forCellWithReuseIdentifier: HorizontalRailCell.reuseIdentifier)
    }

    private func refreshView() {
        guard isViewLoaded, horizontalRailData != nil else { return }
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        collectionView.reloadData()
    }
}

extension HorizontalRailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horizontalRailData?.cellsData.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalRailCell.reuseIdentifier, for: indexPath) as? HorizontalRailCell,
            let data = horizontalRailData?.cellsData[indexPath.item] else { fatalError() }
        cell.configure(with: data)
        return cell
    }
}

extension HorizontalRailViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let horizontalRailData = data as? HorizontalRailData else { return }
        self.horizontalRailData = horizontalRailData
    }
}
