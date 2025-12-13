import UIKit

final class TechnicianCell: UITableViewCell {

    static let identifier = "TechnicianCell"

    // MARK: - UI

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 14
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 5
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        return v
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.numberOfLines = 2              // ✅ allow wrapping
        return lbl
    }()

    private let specializationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()

    private let activeJobsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .gray
        return lbl
    }()

    private let busyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Busy"
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textColor = .white
        lbl.backgroundColor = .systemRed
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 6
        lbl.layer.masksToBounds = true
        lbl.isHidden = true
        return lbl
    }()

    let assignButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Assign", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [
            nameLabel,
            specializationLabel,
            activeJobsLabel,
            busyLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [
            textStack,
            assignButton
        ])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStack)

        // 🔑 IMPORTANT PRIORITIES
        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        assignButton.setContentHuggingPriority(.required, for: .horizontal)
        assignButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),

            assignButton.widthAnchor.constraint(equalToConstant: 80),
            assignButton.heightAnchor.constraint(equalToConstant: 36),

            busyLabel.heightAnchor.constraint(equalToConstant: 20),
            busyLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with technician: Technician, isAssigned: Bool) {
        nameLabel.text = technician.name
        specializationLabel.text = technician.specialization
        activeJobsLabel.text = "Active jobs: \(technician.activeJobs)"

        busyLabel.isHidden = technician.activeJobs <= 3

        assignButton.isEnabled = !isAssigned
        assignButton.alpha = isAssigned ? 0.5 : 1
    }
}
