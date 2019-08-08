//  Copyright © 2019 We Are Mobile First.

import UIKit

struct HorizontalRailCellData {
    let color: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    let emoji: String
    let title: String
}

class HorizontalRailCell: RoundedCardCell {
    static var reuseIdentifier: String {
        return "\(HorizontalRailCell.self)"
    }

    private let backgroundColorView = UIView()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😀"
        label.font = UIFont(name: "Helvetica", size: 100)
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textColor = UIColor.gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(titleLabel)
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: backgroundColorView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backgroundColorView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: backgroundColorView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with data: HorizontalRailCellData) {
        backgroundColorView.backgroundColor = UIColor(red: data.color.red, green: data.color.green, blue: data.color.blue, alpha: data.color.alpha)
        emojiLabel.text = data.emoji
        titleLabel.text = data.title
    }
}
