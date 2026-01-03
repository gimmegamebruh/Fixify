import UIKit

// Custom table view cell used to display a student's request as a card
// Shows request info, image, status, and action buttons
final class StudentRequestCardCell: UITableViewCell {

    // Reuse identifier for table view
    static let reuseID = "StudentRequestCardCell"

    // MARK: - Callbacks

    // Called when Edit button is tapped
    var onEditTapped: (() -> Void)?

    // Called when Cancel button is tapped
    var onCancelTapped: (() -> Void)?

    // MARK: - UI Elements

    // Card container view
    private let cardView = UIView()

    // Labels to show request information
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let priorityLabel = UILabel()
    private let dateLabel = UILabel()

    // Status badge (Pending, Active, Completed, etc.)
    private let statusBadge = StatusBadgeView()

    // Image view for request photo
    private let photoView = UIImageView()

    // Action buttons
    private let editButton = UIFactory.primaryButton(title: "Edit")
    private let cancelButton = UIFactory.secondaryButton(title: "Cancel")

    // Stack view for buttons
    private let buttonStack = UIStackView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // Required initializer (not used)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    // Builds and layouts all UI components inside the cell
    private func setup() {

        backgroundColor = DS.Color.groupedBg
        contentView.isUserInteractionEnabled = true

        // Apply card style
        cardView.dsCard()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Label styling
        titleLabel.font = DS.Font.section()
        locationLabel.font = DS.Font.body()
        priorityLabel.font = DS.Font.body()
        dateLabel.font = DS.Font.caption()
        dateLabel.textColor = DS.Color.subtext

        // Image styling
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = DS.Radius.sm
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoView.isUserInteractionEnabled = false

        // Button actions
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)

        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white

        // Button stack setup
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        // Stack for request info
        let infoStack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            priorityLabel,
            dateLabel,
            statusBadge
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 6

        // Main vertical stack
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

    // MARK: - Configure Cell

    // Populates the cell with request data
    func configure(with request: Request) {

        // Reset callbacks to avoid reuse issues
        onEditTapped = nil
        onCancelTapped = nil

        titleLabel.text = "Title: \(request.title)"
        locationLabel.text = "Location: \(request.location)"
        priorityLabel.text = "Priority: \(request.priority.rawValue.capitalized)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        statusBadge.configure(status: request.status)

        // Reset image for reused cell
        photoView.image = nil
        photoView.isHidden = request.imageURL == nil

        // Load image from URL if available
        if let urlString = request.imageURL,
           let url = URL(string: urlString) {

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }.resume()
        }

        // Configure buttons based on request status
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Show edit and cancel only when request is pending
        if request.status == .pending {
            buttonStack.addArrangedSubview(editButton)
            buttonStack.addArrangedSubview(cancelButton)
        }
        
        // Show rating stars if request was already rated
        if let rating = request.rating {
            let stars = String(repeating: "★", count: rating)
            let ratingLabel = UILabel()
            ratingLabel.text = stars
            ratingLabel.textColor = .systemYellow
            ratingLabel.font = .systemFont(ofSize: 16)
            buttonStack.insertArrangedSubview(ratingLabel, at: 0)
        }
    }

    // MARK: - Button Actions

    // Trigger edit callback
    @objc private func editPressed() {
        onEditTapped?()
    }

    // Trigger cancel callback
    @objc private func cancelPressed() {
        onCancelTapped?()
    }
}
