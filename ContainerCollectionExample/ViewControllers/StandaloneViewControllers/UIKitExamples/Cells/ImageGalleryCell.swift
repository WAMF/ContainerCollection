//  Copyright © 2019 We Are Mobile First.

import UIKit

class GalleryCell: RoundedCardCell {
    static var reuseIdentifier: String {
        return "\(GalleryCell.self)"
    }

    enum Constant {
        static let cornerRadius: CGFloat = 8
    }

    var imageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = Constant.cornerRadius
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage) {
        imageView.image = image
    }
}
