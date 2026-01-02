import UIKit

final class TechnicianCell: UITableViewCell {

    static let identifier = "TechnicianCell"
    var onAssignTapped: (() -> Void)?

    private let card = UIView()
    private let nameLabel = UILabel()
    private let roleLabel = UILabel()
    private let jobsLabel = UILabel()
    private let assignButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.dsCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        nameLabel.font = DS.Font.section()
        nameLabel.textColor = DS.Color.text

        roleLabel.font = DS.Font.caption()
        roleLabel.textColor = DS.Color.subtext

        jobsLabel.font = DS.Font.caption()
        jobsLabel.textColor = DS.Color.subtext

        assignButton.setTitle("Assign", for: .normal)
        assignButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        assignButton.backgroundColor = DS.Color.primary
        assignButton.tintColor = .white
        assignButton.layer.cornerRadius = 12
        assignButton.contentEdgeInsets = UIEdgeInsets(
            top: 8, left: 20, bottom: 8, right: 20
        )

        assignButton.addAction(UIAction { [weak self] _ in
            self?.onAssignTapped?()
        }, for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [
            nameLabel,
            roleLabel,
            jobsLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.alignment = .leading

        let hStack = UIStackView(arrangedSubviews: [
            textStack,
            assignButton
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
    }

    func configure(with technician: Technician, isCurrentlyAssigned: Bool) {

        nameLabel.text = technician.name
        roleLabel.text = technician.specialization
        jobsLabel.text = "Active jobs: \(technician.activeJobs)"

        if isCurrentlyAssigned {
            assignButton.setTitle("Assigned", for: .normal)
            assignButton.isEnabled = false
            assignButton.backgroundColor = DS.Color.secondaryBg
            assignButton.tintColor = DS.Color.subtext
            assignButton.alpha = 0.7
        } else {
            assignButton.setTitle("Assign", for: .normal)
            assignButton.isEnabled = true
            assignButton.backgroundColor = DS.Color.primary
            assignButton.tintColor = .white
            assignButton.alpha = 1.0
        }
    }
}
