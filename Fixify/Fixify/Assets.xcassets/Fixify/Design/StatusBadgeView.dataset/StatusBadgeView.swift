import UIKit

final class StatusBadgeView: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    private func common() {
        font = .systemFont(ofSize: 13, weight: .semibold)
        textAlignment = .center
        textColor = .white
        layer.cornerRadius = DS.Height.badge / 2
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: DS.Height.badge).isActive = true
        widthAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true
    }

    func configure(status: RequestStatus) {
        text = status.rawValue.capitalized
        backgroundColor = status.color
    }
}

