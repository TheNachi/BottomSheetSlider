//
//  View+Extensions.swift
//  BottomSheetSlider
//
//  Created by Munachimso Ugorji on 17/12/2021.
//

import Foundation

extension UIView {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIPanGestureRecognizer {
    public var direction: UIPanGestureRecognizerDirection {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)

        var direction: UIPanGestureRecognizerDirection

        if isVertical {
            direction = velocity.y > 0 ? .topToBottom : .bottomToTop
        } else {
            direction = velocity.x > 0 ? .leftToRight : .rightToLeft
        }

        return direction
    }

    public func isQuickSwipe(for orientation: TransitionOrientation) -> Bool {
        let velocity = self.velocity(in: view)
        return isQuickSwipeForVelocity(velocity, for: orientation)
    }

    private func isQuickSwipeForVelocity(_ velocity: CGPoint, for orientation: TransitionOrientation) -> Bool {
        switch orientation {
        case .unknown : return false
        case .topToBottom : return velocity.y > 1000
        case .bottomToTop : return velocity.y < -1000
        case .leftToRight : return velocity.x > 8000
        case .rightToLeft : return velocity.x < -8000
        }
    }
}
