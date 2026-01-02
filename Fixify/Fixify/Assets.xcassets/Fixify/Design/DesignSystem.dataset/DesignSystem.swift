import UIKit

enum DS {

    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // MARK: - Corner Radius
    enum Radius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }

    // MARK: - Typography
    enum Font {
        static func title() -> UIFont { .systemFont(ofSize: 24, weight: .bold) }
        static func section() -> UIFont { .systemFont(ofSize: 18, weight: .semibold) }
        static func body() -> UIFont { .systemFont(ofSize: 16, weight: .regular) }
        static func caption() -> UIFont { .systemFont(ofSize: 13, weight: .regular) }
        static func button() -> UIFont { .systemFont(ofSize: 17, weight: .semibold) }
    }

    // MARK: - Colors (Dynamic / Dark Mode Ready)
    enum Color {
        static var bg: UIColor { .systemBackground }
        static var secondaryBg: UIColor { .secondarySystemBackground }
        static var groupedBg: UIColor { .systemGroupedBackground }

        static var text: UIColor { .label }
        static var subtext: UIColor { .secondaryLabel }

        static var primary: UIColor { .systemBlue }
        static var divider: UIColor { .separator }
    }

    // MARK: - Shadow (Cards)
    enum Shadow {
        static let color = UIColor.black.cgColor
        static let opacity: Float = 0.10
        static let radius: CGFloat = 10
        static let offset = CGSize(width: 0, height: 4)
    }

    // MARK: - Standard Heights
    enum Height {
        static let button: CGFloat = 50
        static let badge: CGFloat = 24
        static let textField: CGFloat = 46
        static let image: CGFloat = 220
    }
}

