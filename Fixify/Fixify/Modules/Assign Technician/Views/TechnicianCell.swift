import UIKit

final class TechnicianCell: UITableViewCell {

    static let identifier = "TechnicianCell"

    var onAssignTapped: (() -> Void)?

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

        assignButton.setTitle("Assign", for: .normal)
        assignButton.backgroundColor = .systemBlue
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.layer.cornerRadius = 10
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            jobsLabel,
            assignButton
        ])
        stack.axis = .vertical
        stack.spacing = 8

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with technician: Technician, isBusy: Bool) {
        nameLabel.text = technician.name

        // 🔹 activeJobs = IN-PROGRESS only
        jobsLabel.text = "Active jobs: \(technician.activeJobs)"

        // 🔥 Assign is ALWAYS allowed now
        assignButton.isEnabled = true
        assignButton.alpha = 1
        assignButton.backgroundColor = .systemBlue
    }

    @objc private func assignTapped() {
        onAssignTapped?()
    }
}
