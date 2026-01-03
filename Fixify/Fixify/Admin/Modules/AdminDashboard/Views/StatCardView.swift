import UIKit

final class StatCardView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private var isHighlighted: Bool = false

    init(title: String, value: String, highlighted: Bool = false) {
        self.isHighlighted = highlighted
        super.init(frame: .zero)

        backgroundColor = dynamicCardBackgroundColor()
        layer.cornerRadius = 14
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.black.cgColor

        heightAnchor.constraint(equalToConstant: 90).isActive = true

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = dynamicSecondaryTextColor()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1

        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 22)
        valueLabel.textColor = highlighted ? .systemBlue : dynamicPrimaryTextColor()
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 1

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateColorsForCurrentTraitCollection()
        }
    }

    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Update Colors
    
    private func updateColorsForCurrentTraitCollection() {
        backgroundColor = dynamicCardBackgroundColor()
        titleLabel.textColor = dynamicSecondaryTextColor()
        
        // Keep highlighted color or update to dynamic color
        if !isHighlighted {
            valueLabel.textColor = dynamicPrimaryTextColor()
        }
        
        layer.shadowColor = UIColor.black.cgColor
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicCardBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
    }
    
    private func dynamicPrimaryTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    private func dynamicSecondaryTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray
        }
    }
    
    // MARK: - Public Update Method
    
    /// Updates the value text and color
    func updateValue(_ newValue: String, highlighted: Bool = false) {
        isHighlighted = highlighted
        valueLabel.text = newValue
        valueLabel.textColor = highlighted ? .systemBlue : dynamicPrimaryTextColor()
    }
}
