import UIKit

class RequestTableViewCell: UITableViewCell {

    static let reuseID = "RequestCell"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let priorityLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    private let thumbnailImageView = UIImageView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        backgroundColor = .systemGroupedBackground
        selectionStyle = .none

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2

        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel

        priorityLabel.font = .systemFont(ofSize: 14)
        priorityLabel.textColor = .secondaryLabel

        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .secondaryLabel

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel

        statusLabel.font = .boldSystemFont(ofSize: 12)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 10
        statusLabel.clipsToBounds = true
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(thumbnailImageView)


        contentView.addSubview(cardView)

        [titleLabel, locationLabel, priorityLabel,
         categoryLabel, dateLabel, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        cardView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.leadingAnchor, constant: -12),

            // Status badge (top-right)
            statusLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            statusLabel.heightAnchor.constraint(equalToConstant: 22),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),

            // Location
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            locationLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            // Priority
            priorityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            priorityLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            priorityLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            // Category
            categoryLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            // Date
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            // Thumbnail image on top-right
            thumbnailImageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),

        ])
    }

    func configure(with request: Request) {
        titleLabel.text = request.title
        locationLabel.text = "Location: \(request.location)"
        priorityLabel.text = "Priority: \(request.priority)"
        categoryLabel.text = "Category: \(request.category)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        statusLabel.text = request.status.displayName
        statusLabel.backgroundColor = request.status.color
        statusLabel.textColor = .white
        
        thumbnailImageView.image = request.photo

    }
}

