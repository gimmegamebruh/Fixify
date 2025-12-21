import UIKit

final class EscalatedRequestCell: UITableViewCell {

    static let identifier = "EscalatedRequestCell"

    var onViewTap: (() -> Void)?

    private let card = UIView()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let badgeLabel = UILabel()
    private let viewButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear

        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 0, height: 3)

        titleLabel.font = .boldSystemFont(ofSize: 16)
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .darkGray

        badgeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.layer.masksToBounds = true

        viewButton.setTitle("View", for: .normal)
        viewButton.setTitleColor(.white, for: .normal)
        viewButton.backgroundColor = .systemBlue
        viewButton.layer.cornerRadius = 10
        viewButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        viewButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 6

        let rightStack = UIStackView(arrangedSubviews: [
            badgeLabel,
            viewButton
        ])
        rightStack.axis = .vertical
        rightStack.spacing = 8
        rightStack.alignment = .trailing

        let mainStack = UIStackView(arrangedSubviews: [
            textStack,
            rightStack
        ])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .top
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(card)
        card.addSubview(mainStack)

        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            mainStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),

            badgeLabel.heightAnchor.constraint(equalToConstant: 22),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),

            viewButton.widthAnchor.constraint(equalToConstant: 70),
            viewButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    // ✅ NEW CONFIGURE METHOD
    func configure(with request: Request, escalationType: EscalationFilter) {
        titleLabel.text = request.title
        locationLabel.text = request.location

        switch escalationType {
        case .overdue:
            badgeLabel.text = "OVERDUE"
            badgeLabel.backgroundColor = .systemOrange
        case .urgent:
            badgeLabel.text = "URGENT"
            badgeLabel.backgroundColor = .systemRed
        case .all:
            badgeLabel.text = "ESCALATED"
            badgeLabel.backgroundColor = .systemPurple
        }
    }

    @objc private func viewTapped() {
        onViewTap?()
    }
}
