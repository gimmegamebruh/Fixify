import UIKit

final class RequestCell: UITableViewCell {

    static let identifier = "RequestCell"

    var onAssignTap: (() -> Void)?
    var onEscalateTap: (() -> Void)?   // 🔥 NEW (logic only)

    // MARK: - UI

    private let card = UIView()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()

    private let statusBadge = PaddedLabel()
    private let photoView = UIImageView()
    private let assignButton = UIButton(type: .system)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLongPress()   // 🔥 NEW
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup (UNCHANGED)

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowRadius = 10
        card.layer.shadowOffset = CGSize(width: 0, height: 6)
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label

        locationLabel.font = .systemFont(ofSize: 15)
        locationLabel.textColor = .secondaryLabel

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .tertiaryLabel

        statusBadge.font = .systemFont(ofSize: 14, weight: .semibold)
        statusBadge.textColor = .white
        statusBadge.layer.cornerRadius = 16
        statusBadge.clipsToBounds = true
        statusBadge.textInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        statusBadge.translatesAutoresizingMaskIntoConstraints = false

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 14
        photoView.backgroundColor = UIColor(
            red: 0.92, green: 0.94, blue: 0.96, alpha: 1
        )
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        photoView.isHidden = true

        assignButton.setTitle("Assign", for: .normal)
        assignButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        assignButton.backgroundColor = .systemBlue
        assignButton.tintColor = .white
        assignButton.layer.cornerRadius = 12
        assignButton.contentEdgeInsets = UIEdgeInsets(
            top: 10, left: 22, bottom: 10, right: 22
        )
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)

        let infoStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            dateLabel
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoStack.alignment = .leading

        let mainStack = UIStackView(arrangedSubviews: [
            infoStack,
            photoView,
            assignButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(mainStack)
        card.addSubview(statusBadge)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            mainStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            statusBadge.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            statusBadge.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - NEW: Long Press (NO UI CHANGE)

    private func setupLongPress() {
        let press = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressed(_:))
        )
        press.minimumPressDuration = 0.5
        card.addGestureRecognizer(press)
    }

    @objc private func longPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        onEscalateTap?()
    }

    // MARK: - Configure (UNCHANGED)

    func configure(with request: Request) {

        titleLabel.text = "Title: \(request.title)"
        locationLabel.text = "Location: \(request.location)"

        let df = DateFormatter()
        df.dateStyle = .medium
        dateLabel.text = "Date: \(df.string(from: request.dateCreated))"

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

        let canAssign = request.status.canAssignTechnician
        assignButton.isEnabled = canAssign
        assignButton.alpha = canAssign ? 1.0 : 0.45
        assignButton.backgroundColor = canAssign
            ? .systemBlue
            : .systemBlue.withAlphaComponent(0.6)

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
    
    override func prepareForReuse() {
        super.prepareForReuse()

        statusBadge.text = nil
        statusBadge.backgroundColor = .clear
        photoView.image = nil
    }


    // MARK: - Actions

    @objc private func assignTapped() {
        onAssignTap?()
    }
}
