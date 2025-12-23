import UIKit

final class RequestCell: UITableViewCell {

    static let identifier = "RequestCell"
    var onAssignTap: (() -> Void)?

    private let card = UIView()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusBadge = StatusBadgeView()
    private let photoView = UIImageView()
    private let assignButton = UIButton(type: .system)

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
        dateLabel.font = DS.Font.caption()
        locationLabel.textColor = DS.Color.subtext
        dateLabel.textColor = DS.Color.subtext

        // IMAGE (same as student)
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = DS.Radius.sm
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoView.isHidden = true

        // SMALL PILL BUTTON
        assignButton.setTitle("Assign", for: .normal)
        assignButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        assignButton.backgroundColor = DS.Color.primary
        assignButton.tintColor = .white
        assignButton.layer.cornerRadius = 18
        assignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            assignButton.widthAnchor.constraint(equalToConstant: 90),
            assignButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)

        let buttonContainer = UIView()
        buttonContainer.addSubview(assignButton)

        NSLayoutConstraint.activate([
            assignButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            assignButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            assignButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            dateLabel,
            statusBadge,
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

    func configure(with request: Request) {

        titleLabel.text = request.title
        locationLabel.text = request.location

        let df = DateFormatter()
        df.dateStyle = .medium
        dateLabel.text = df.string(from: request.dateCreated)

        statusBadge.configure(status: request.status)

        let canAssign = request.status == .pending || request.status == .escalated
        assignButton.isEnabled = canAssign
        assignButton.alpha = canAssign ? 1 : 0.4

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

    @objc private func assignTapped() {
        onAssignTap?()
    }
}
