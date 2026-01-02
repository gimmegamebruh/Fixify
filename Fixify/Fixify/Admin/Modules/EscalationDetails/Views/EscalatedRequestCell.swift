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

        card.dsCard()
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = DS.Font.section()
        locationLabel.font = DS.Font.body()
        locationLabel.textColor = DS.Color.subtext

        badgeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        badgeLabel.textColor = .white
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.clipsToBounds = true
        badgeLabel.textAlignment = .center
        badgeLabel.setContentHuggingPriority(.required, for: .horizontal)

        viewButton.setTitle("View", for: .normal)
        viewButton.backgroundColor = DS.Color.primary
        viewButton.tintColor = .white
        viewButton.layer.cornerRadius = 16
        viewButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)

        let topRow = UIStackView(arrangedSubviews: [titleLabel, badgeLabel])
        topRow.axis = .horizontal
        topRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [
            topRow,
            locationLabel,
            viewButton
        ])

        stack.axis = .vertical
        stack.spacing = 12

        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),

            viewButton.heightAnchor.constraint(equalToConstant: 36),
            viewButton.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

    func configure(with request: Request, type: EscalationFilter?) {

        titleLabel.text = request.title
        locationLabel.text = request.location

        switch type {
        case .some(.overdue):
            badgeLabel.text = "OVERDUE"
            badgeLabel.backgroundColor = .systemRed

        case .some(.urgent):
            badgeLabel.text = "URGENT"
            badgeLabel.backgroundColor = .systemOrange

        case .some(.all), .none:
            badgeLabel.text = "ATTENTION"
            badgeLabel.backgroundColor = .systemPurple
        }



        badgeLabel.padding(left: 10, right: 10, top: 4, bottom: 4)
    }

    @objc private func viewTapped() {
        onViewTap?()
    }
}
