import UIKit

class RequestCell: UITableViewCell {

    static let identifier = "RequestCell"

    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        return v
    }()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()

    private let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor.yellow.withAlphaComponent(0.9)
        lbl.layer.cornerRadius = 8
        lbl.layer.masksToBounds = true
        return lbl
    }()

    private let requestImage: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()

    private var imageHeightConstraint: NSLayoutConstraint!

    let assignButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Assign", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(containerView)

        [titleLabel, locationLabel, dateLabel,
         statusLabel, requestImage, assignButton]
            .forEach {
                containerView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        setupLabels()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.textColor = .gray
    }

    func configure(with model: Request) {
        titleLabel.text = "Title: \(model.title)"
        locationLabel.text = "Location: \(model.location)"

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = "Date: \(formatter.string(from: model.dateCreated))"

        statusLabel.text = model.status.rawValue

        // 🔥 DYNAMIC IMAGE BEHAVIOR
        if let imageName = model.imageName,
           let img = UIImage(named: imageName) {
            requestImage.isHidden = false
            requestImage.image = img
            imageHeightConstraint.constant = 180
        } else {
            requestImage.isHidden = true
            requestImage.image = nil
            imageHeightConstraint.constant = 0
        }

        layoutIfNeeded()
    }

    private func setupConstraints() {

        containerView.translatesAutoresizingMaskIntoConstraints = false

        imageHeightConstraint = requestImage.heightAnchor.constraint(equalToConstant: 180)
        imageHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            statusLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 22),

            requestImage.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            requestImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            requestImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageHeightConstraint,

            assignButton.topAnchor.constraint(equalTo: requestImage.bottomAnchor, constant: 16),
            assignButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            assignButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            assignButton.heightAnchor.constraint(equalToConstant: 44),
            assignButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}
