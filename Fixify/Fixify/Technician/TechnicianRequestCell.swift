import UIKit

final class TechnicianRequestCell: UITableViewCell {

    static let reuseID = "TechnicianRequestCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let metaLabel = UILabel()
    private let statusBadge = PaddingLabel()
    private let container = UIView()
    private let photoView = UIImageView()
    private var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with request: Request) {
        titleLabel.text = request.title
        subtitleLabel.text = "\(request.location) • \(request.priority.rawValue.capitalized)"
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        let assignedText: String
        if CurrentUser.role == .technician,
           let techID = CurrentUser.userID,
           let assigned = request.assignedTechnicianID {
            assignedText = assigned == techID ? "Assigned to you" : "Assigned to another tech"
        } else if request.assignedTechnicianID == nil {
            assignedText = "Unassigned"
        } else {
            assignedText = "Assigned"
        }
        metaLabel.text = "Submitted \(df.string(from: request.dateCreated)) • \(assignedText)"

        statusBadge.text = request.status.rawValue.capitalized
        statusBadge.backgroundColor = request.status.color.withAlphaComponent(0.15)
        statusBadge.textColor = request.status.color

        container.layer.borderColor = request.priority.color.withAlphaComponent(0.7).cgColor

        imageTask?.cancel()
        photoView.image = nil
        if let urlString = request.imageURL,
           let url = URL(string: urlString) {
            photoView.isHidden = false
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let self else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }
            imageTask?.resume()
        } else {
            photoView.isHidden = true
        }
    }

    private func setupUI() {
        container.layer.cornerRadius = 12
        container.backgroundColor = .systemBackground
        container.layer.borderColor = UIColor.separator.cgColor
        container.layer.borderWidth = 1.5
        container.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 17)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        metaLabel.font = .systemFont(ofSize: 12)
        metaLabel.textColor = .tertiaryLabel

        statusBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        statusBadge.layer.cornerRadius = 6
        statusBadge.clipsToBounds = true
        statusBadge.textAlignment = .center

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 10
        photoView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        photoView.backgroundColor = .secondarySystemBackground

        let stack = UIStackView(arrangedSubviews: [photoView, titleLabel, subtitleLabel, metaLabel, statusBadge])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        photoView.image = nil
        photoView.isHidden = true
    }
}

// Small padded label for status badges
final class PaddingLabel: UILabel {
    private let inset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width + inset.left + inset.right,
                      height: base.height + inset.top + inset.bottom)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
}
