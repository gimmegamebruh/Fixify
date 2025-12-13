//
//  RequestCardCell.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class RequestCardCell: UITableViewCell {

    static let reuseIdentifier = "RequestCardCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let metaLabel = UILabel()
    private let priorityBadge = UILabel()
    private let statusBadge = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12

        [titleLabel, subtitleLabel, metaLabel, priorityBadge, statusBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        metaLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        metaLabel.textColor = .tertiaryLabel

        priorityBadge.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        priorityBadge.textAlignment = .center
        priorityBadge.textColor = .white
        priorityBadge.layer.cornerRadius = 12
        priorityBadge.layer.masksToBounds = true

        statusBadge.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        statusBadge.textAlignment = .center
        statusBadge.textColor = .systemBlue
        statusBadge.layer.cornerRadius = 4
        statusBadge.layer.borderWidth = 1
        statusBadge.layer.borderColor = UIColor.systemBlue.cgColor

        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            metaLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            priorityBadge.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 12),
            priorityBadge.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priorityBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            priorityBadge.heightAnchor.constraint(equalToConstant: 24),
            priorityBadge.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            statusBadge.centerYAnchor.constraint(equalTo: priorityBadge.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            statusBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with request: MaintenanceRequest) {
        titleLabel.text = "\(request.id) · \(request.title)"
        subtitleLabel.text = request.location
        let dateString = request.submissionDate.formatted()
        metaLabel.text = "Submitted \(dateString)"

        priorityBadge.text = request.priority.rawValue
        priorityBadge.backgroundColor = priorityColor(for: request.priority)

        statusBadge.text = request.status.rawValue
        statusBadge.textColor = statusColor(for: request.status)
        statusBadge.layer.borderColor = statusColor(for: request.status).cgColor
    }

    private func priorityColor(for priority: MaintenancePriority) -> UIColor {
        switch priority {
        case .low:
            return UIColor.systemGreen
        case .medium:
            return UIColor.systemBlue
        case .high:
            return UIColor.systemOrange
        case .urgent:
            return UIColor.systemRed
        }
    }

    private func statusColor(for status: MaintenanceStatus) -> UIColor {
        switch status {
        case .pending:
            return UIColor.systemGray
        case .inProgress:
            return UIColor.systemIndigo
        case .completed:
            return UIColor.systemGreen
        }
    }
}
