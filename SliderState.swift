

import Foundation

enum SliderState {
    case expanded
    case collapsed
}

public enum UIPanGestureRecognizerDirection {
    case undefined
    case bottomToTop
    case topToBottom
    case rightToLeft
    case leftToRight
}

public enum TransitionOrientation {
    case unknown
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
}
