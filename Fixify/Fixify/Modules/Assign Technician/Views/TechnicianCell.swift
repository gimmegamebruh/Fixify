//
//  TechnicianCell.swift
//  Fixify
//

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

    func configure(
        with technician: Technician,
        isBusy: Bool,
        isCurrentlyAssigned: Bool
    ) {
        nameLabel.text = technician.name
        jobsLabel.text = "Active jobs: \(technician.activeJobs)"

        if isCurrentlyAssigned {
            // 🔵 CURRENTLY ASSIGNED TECH
            assignButton.setTitle("Assigned", for: .normal)
            assignButton.backgroundColor = .systemBlue.withAlphaComponent(0.3)
            assignButton.setTitleColor(.systemBlue, for: .normal)
            assignButton.isEnabled = false

        } else {
            // ✅ AVAILABLE FOR ASSIGNMENT
            assignButton.setTitle("Assign", for: .normal)
            assignButton.backgroundColor = .systemBlue
            assignButton.setTitleColor(.white, for: .normal)
            assignButton.isEnabled = true
        }
    }

    @objc private func assignTapped() {
        onAssignTapped?()
    }
}
