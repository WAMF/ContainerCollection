//  Copyright © 2019 We Are Mobile First.

import UIKit

public extension UIView {
    private func addAutolayoutSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }

    public func addAutolayoutSubview(_ subview: UIView) {
        addAutolayoutSubviews(subview)
    }

    @available(iOS 11.0, tvOS 11.0, *)
    public func anchorToSuperviewSafeLayoutEdges(margins: UIEdgeInsets = .zero) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: margins.left),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -margins.right),
            safeAreaLayoutGuide.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: margins.top),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -margins.bottom)
        ])
    }

    public func fillSuperview(margins: UIEdgeInsets = .zero) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: margins.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -margins.right),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: margins.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -margins.bottom)
        ])
    }

    public func frameToSuperviewBounds(margins: UIEdgeInsets = .zero) {
        if #available(iOS 11.0, tvOS 11.0, *) {
            anchorToSuperviewSafeLayoutEdges(margins: margins)
        } else {
            fillSuperview(margins: margins)
        }
    }
}
