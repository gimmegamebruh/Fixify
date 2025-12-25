//
//  TechnicianNotificationCell.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class TechnicianNotificationCell: UITableViewCell {

    static let reuseID = "TechnicianNotificationCell"

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let container = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with notification: TechnicianNotification) {

        titleLabel.text = notification.title
        subtitleLabel.text = notification.subtitle

        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        dateLabel.text = df.string(from: notification.date)

        switch notification.type {
        case .assigned:
            iconView.image = UIImage(systemName: "briefcase.fill")
            iconView.tintColor = .systemBlue

        case .scheduled:
            iconView.image = UIImage(systemName: "calendar.circle.fill")
            iconView.tintColor = .systemOrange

        case .completed:
            iconView.image = UIImage(systemName: "checkmark.circle.fill")
            iconView.tintColor = .systemGreen
        }
    }

    private func setupUI() {

        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            dateLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [
            iconView,
            stack
        ])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(hStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
    }
}
