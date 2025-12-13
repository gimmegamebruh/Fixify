import UIKit

final class RequestCell: UITableViewCell {

    static let identifier = "RequestCell"

    // MARK: - Callback
    var onAssignTap: (() -> Void)?

    // MARK: - UI

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 18
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        return v
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 17)
        lbl.textColor = .black
        return lbl
    }()

    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        return lbl
    }()

    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        return lbl
    }()

    private let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .semibold)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.backgroundColor = UIColor.systemYellow
        lbl.layer.cornerRadius = 8
        lbl.layer.masksToBounds = true
        return lbl
    }()

    private let requestImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 14
        iv.clipsToBounds = true
        return iv
    }()

    private let assignButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Assign", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()

    // MARK: - Constraint reference
    private var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)

        [titleLabel,
         locationLabel,
         dateLabel,
         statusLabel,
         requestImageView,
         assignButton].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cardView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()

        assignButton.addTarget(self,
                               action: #selector(assignTapped),
                               for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(with request: Request) {

        titleLabel.text = "Title: \(request.title)"
        locationLabel.text = "Location: \(request.location)"

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = "Date: \(formatter.string(from: request.dateCreated))"

        statusLabel.text = request.status.rawValue

        // 🔑 IMAGE HANDLING FIX
        if let imageName = request.imageName,
           let image = UIImage(named: imageName) {

            requestImageView.image = image
            requestImageView.isHidden = false
            imageHeightConstraint.constant = 180

        } else {
            requestImageView.image = nil
            requestImageView.isHidden = true
            imageHeightConstraint.constant = 0
        }
    }

    // MARK: - Actions

    @objc private func assignTapped() {
        onAssignTap?()
    }

    // MARK: - Layout

    private func setupConstraints() {

        imageHeightConstraint = requestImageView.heightAnchor.constraint(equalToConstant: 180)

        NSLayoutConstraint.activate([
            // Card
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            // Location
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            // Date
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            // Status
            statusLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 22),

            // Image
            requestImageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            requestImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            requestImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            imageHeightConstraint,

            // Assign Button
            assignButton.topAnchor.constraint(equalTo: requestImageView.bottomAnchor, constant: 16),
            assignButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            assignButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            assignButton.heightAnchor.constraint(equalToConstant: 44),
            assignButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}
