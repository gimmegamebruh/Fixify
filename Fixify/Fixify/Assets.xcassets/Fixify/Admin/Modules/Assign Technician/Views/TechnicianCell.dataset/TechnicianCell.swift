import UIKit

final class TechnicianCell: UITableViewCell {

    static let identifier = "TechnicianCell"
    var onAssignTapped: (() -> Void)?

    private let card = UIView()
    private let nameLabel = UILabel()
    private let jobsLabel = UILabel()
    private let assignButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.isUserInteractionEnabled = true

        card.dsCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        nameLabel.font = DS.Font.section()
        jobsLabel.font = DS.Font.body()
        jobsLabel.textColor = DS.Color.subtext

        // button style
        assignButton.setTitle("Assign", for: .normal)
        assignButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        assignButton.backgroundColor = DS.Color.primary
        assignButton.tintColor = .white
        assignButton.layer.cornerRadius = 18
        assignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            assignButton.heightAnchor.constraint(equalToConstant: 36),
            assignButton.widthAnchor.constraint(equalToConstant: 110)
        ])

        // 🔥 UIAction guarantees taps
        assignButton.addAction(UIAction { [weak self] _ in
            print("✅ Assign button tapped in TechnicianCell")
            self?.onAssignTapped?()
        }, for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameLabel, jobsLabel, assignButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
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

    func configure(with technician: Technician, isCurrentlyAssigned: Bool) {

        nameLabel.text = technician.name
        jobsLabel.text = "Active jobs: \(technician.activeJobs)"

        if isCurrentlyAssigned {
            assignButton.setTitle("Assigned", for: .normal)
            assignButton.backgroundColor = DS.Color.secondaryBg
            assignButton.setTitleColor(DS.Color.primary, for: .normal)
            assignButton.isEnabled = false
            assignButton.alpha = 0.7
        } else {
            assignButton.setTitle("Assign", for: .normal)
            assignButton.backgroundColor = DS.Color.primary
            assignButton.setTitleColor(.white, for: .normal)
            assignButton.isEnabled = true
            assignButton.alpha = 1.0
        }
    }
}
