import UIKit

extension UIView {

    func dsCard() {
        backgroundColor = DS.Color.secondaryBg
        layer.cornerRadius = DS.Radius.md
        layer.masksToBounds = false
        layer.shadowColor = DS.Shadow.color
        layer.shadowOpacity = DS.Shadow.opacity
        layer.shadowRadius = DS.Shadow.radius
        layer.shadowOffset = DS.Shadow.offset
    }

    func dsPill() {
        backgroundColor = DS.Color.secondaryBg
        layer.cornerRadius = DS.Height.badge / 2
        clipsToBounds = true
    }

    func dsBorder() {
        layer.borderWidth = 1
        layer.borderColor = DS.Color.divider.cgColor
    }
}

