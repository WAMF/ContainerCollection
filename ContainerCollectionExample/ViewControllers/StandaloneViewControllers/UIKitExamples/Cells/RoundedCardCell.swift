//  Copyright © 2019 We Are Mobile First.

import UIKit

class RoundedCardCell: UICollectionViewCell {
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
    private var isPressed: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGestureRecognizer()
    }

    // MARK: - Gesture Recognizer

    private func configureGestureRecognizer() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer?.minimumPressDuration = 0.5
        addGestureRecognizer(longPressGestureRecognizer!)
    }

    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }

    private func handleLongPressBegan() {
        guard !isPressed else {
            return
        }

        isPressed = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                           self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }

    private func handleLongPressEnded() {
        guard isPressed else {
            return
        }

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                           self.transform = CGAffineTransform.identity
        }) { _ in
            self.isPressed = false
        }
    }
}
