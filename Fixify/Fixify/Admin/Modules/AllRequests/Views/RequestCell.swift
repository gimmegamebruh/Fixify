import UIKit

final class RequestCell: UITableViewCell {

    static let identifier = "RequestCell"

    var onAssignTap: (() -> Void)?

    private let card = UIView()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusBadge = UILabel()
    private let assignButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

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
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .gray

        statusBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        statusBadge.textColor = .white
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 10
        statusBadge.layer.masksToBounds = true

        assignButton.setTitle("Assign", for: .normal)
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.layer.cornerRadius = 12
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            dateLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 6

        let rightStack = UIStackView(arrangedSubviews: [
            statusBadge,
            assignButton
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

            assignButton.widthAnchor.constraint(equalToConstant: 90),
            assignButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    // MARK: - Configuration

    func configure(with request: Request) {

        titleLabel.text = request.title
        locationLabel.text = request.location

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: request.dateCreated)

        statusBadge.text = request.status.rawValue.uppercased()

        switch request.status {
        case .pending:
            statusBadge.backgroundColor = .systemYellow
        case .assigned:
            statusBadge.backgroundColor = .systemTeal

        case .active:
            statusBadge.backgroundColor = .systemBlue

        case .escalated:
            statusBadge.backgroundColor = .systemOrange

        case .completed:
            statusBadge.backgroundColor = .systemGreen

        case .cancelled:
            statusBadge.backgroundColor = .systemRed
        }

        // 🔒 Business rule: only pending / escalated can be assigned
        let canAssign = request.status == .pending || request.status == .escalated

        assignButton.isEnabled = canAssign
        assignButton.backgroundColor = canAssign ? .systemBlue : .systemGray
        assignButton.alpha = canAssign ? 1.0 : 0.5
    }

    @objc private func assignTapped() {
        onAssignTap?()
    }
}
