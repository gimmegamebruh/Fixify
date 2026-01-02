import UIKit

final class StudentRequestCardCell: UITableViewCell {

    static let reuseID = "StudentRequestCardCell"

    // MARK: - Callbacks
    var onEditTapped: (() -> Void)?
    var onCancelTapped: (() -> Void)?

    // MARK: - UI
    private let cardView = UIView()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let priorityLabel = UILabel()
    private let dateLabel = UILabel()

    private let statusBadge = StatusBadgeView()
    private let photoView = UIImageView()

    private let editButton = UIFactory.primaryButton(title: "Edit")
    private let cancelButton = UIFactory.secondaryButton(title: "Cancel")

    private let buttonStack = UIStackView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = DS.Color.groupedBg
        contentView.isUserInteractionEnabled = true

        cardView.dsCard()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        titleLabel.font = DS.Font.section()
        locationLabel.font = DS.Font.body()
        priorityLabel.font = DS.Font.body()
        dateLabel.font = DS.Font.caption()
        dateLabel.textColor = DS.Color.subtext

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = DS.Radius.sm
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoView.isUserInteractionEnabled = false

        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)

        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white

        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let infoStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            priorityLabel,
            dateLabel,
            statusBadge
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 6

        let mainStack = UIStackView(arrangedSubviews: [
            infoStack,
            photoView,
            buttonStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configure
    func configure(with request: Request) {

        // Reset callbacks (IMPORTANT for reuse)
        onEditTapped = nil
        onCancelTapped = nil

        titleLabel.text = "Title: \(request.title)"
        locationLabel.text = "Location: \(request.location)"
        priorityLabel.text = "Priority: \(request.priority.rawValue.capitalized)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        statusBadge.configure(status: request.status)

        // Image
        photoView.image = nil
        photoView.isHidden = request.imageURL == nil

        if let urlString = request.imageURL,
           let url = URL(string: urlString) {

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }.resume()
        }

        // Buttons logic
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if request.status == .pending {
            buttonStack.addArrangedSubview(editButton)
            buttonStack.addArrangedSubview(cancelButton)
        }
        
        if let rating = request.rating {
            let stars = String(repeating: "★", count: rating)
            let ratingLabel = UILabel()
            ratingLabel.text = stars
            ratingLabel.textColor = .systemYellow
            ratingLabel.font = .systemFont(ofSize: 16)
            buttonStack.insertArrangedSubview(ratingLabel, at: 0)
        }

    }

    // MARK: - Actions
    @objc private func editPressed() {
        onEditTapped?()
    }

    @objc private func cancelPressed() {
        onCancelTapped?()
    }
}

