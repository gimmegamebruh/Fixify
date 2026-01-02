import UIKit

extension UILabel {

    func padding(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        let inset = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )

        // ⚠️ UILabel doesn't support padding natively,
        // so we adjust drawing rect
        let originalBounds = bounds
        let paddedBounds = originalBounds.inset(by: inset)
        drawText(in: paddedBounds)
    }
}
