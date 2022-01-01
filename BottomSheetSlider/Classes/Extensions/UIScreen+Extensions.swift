import Foundation
import UIKit

extension UIScreen {
    static var isPhoneXAndAbove: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    static var fullPeekHeight: CGFloat {
        let height = UIScreen.main.bounds.height
        return UIScreen.isPhoneXAndAbove ? height - 40: height - 20
    }

}
