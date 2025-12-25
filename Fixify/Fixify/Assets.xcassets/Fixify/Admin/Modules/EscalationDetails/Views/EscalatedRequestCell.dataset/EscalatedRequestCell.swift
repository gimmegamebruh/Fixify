import UIKit

final class EscalatedRequestCell: UITableViewCell {

    static let identifier = "EscalatedRequestCell"
    var onViewTap: (() -> Void)?

    private let card = UIView()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let badgeLabel = UILabel()
    private let photoView = UIImageView()
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
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        titleLabel.font = DS.Font.section()
        locationLabel.font = DS.Font.body()
        locationLabel.textColor = DS.Color.subtext

        badgeLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        badgeLabel.textColor = .white
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.clipsToBounds = true
        badgeLabel.textAlignment = .center

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = DS.Radius.sm
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoView.isHidden = true

        viewButton.setTitle("View", for: .normal)
        viewButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        viewButton.backgroundColor = DS.Color.primary
        viewButton.tintColor = .white
        viewButton.layer.cornerRadius = 18
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewButton.widthAnchor.constraint(equalToConstant: 90),
            viewButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        viewButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)

        let buttonContainer = UIView()
        buttonContainer.addSubview(viewButton)

        NSLayoutConstraint.activate([
            viewButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            viewButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            viewButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            badgeLabel,
            photoView,
            buttonContainer
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(stack)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
    }

    func configure(with request: Request, escalationType: EscalationFilter) {

        titleLabel.text = request.title
        locationLabel.text = request.location

        switch escalationType {
        case .overdue:
            badgeLabel.text = "OVERDUE"
            badgeLabel.backgroundColor = .systemRed
        case .urgent:
            badgeLabel.text = "URGENT"
            badgeLabel.backgroundColor = .systemOrange
        case .all:
            badgeLabel.text = "ESCALATED"
            badgeLabel.backgroundColor = .systemPurple
        }

        photoView.image = nil
        photoView.isHidden = request.imageURL == nil

        if let urlString = request.imageURL,
           let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self?.photoView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    @objc private func viewTapped() {
        onViewTap?()
    }
}
