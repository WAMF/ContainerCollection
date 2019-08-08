//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import UIKit

struct ImageData: ComponentData, Equatable {
    enum Variant: String {
        case bottomDetail
        case sideDetail
    }

    let imageName: String
    let title: String
    let subTitle: String
    let variant: Variant
}

class ImageViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    var imageData: ImageData? {
        didSet { refreshView() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }

    deinit {
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    private func refreshView() {
        guard isViewLoaded, let data = imageData else { return }
        imageView.image = UIImage(named: data.imageName)
        titleLabel.text = data.title
        subtitleLabel.text = data.subTitle
    }
}

extension ImageViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let imageData = data as? ImageData, imageData != self.imageData else { return }
        self.imageData = imageData
    }
}
