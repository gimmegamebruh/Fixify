//
//  StudentNotificationCell.swift
//  Fixify
//
//  This custom table view cell is used to display a notification for the student
//  It shows an icon, title, short message, and time
//

import UIKit

// Custom cell used in the student notifications list
final class StudentNotificationCell: UITableViewCell {

    // Reuse identifier for table view
    static let reuseID = "StudentNotificationCell"

    // Card container view
    private let card = UIView()

    // Icon that represents the notification type
    private let iconView = UIImageView()

    // Main title of the notification
    private let titleLabel = UILabel()

    // Short description or message
    private let subtitleLabel = UILabel()

    // Time label (e.g. "5 minutes ago")
    private let timeLabel = UILabel()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    // Required initializer (not used)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI Setup

    // Builds and layouts all UI elements inside the cell
    private func setupUI() {

        // Disable selection highlight
        selectionStyle = .none
        backgroundColor = .clear

        // Apply card style
        card.dsCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        // Icon setup
        iconView.contentMode = .scaleAspectFit

        // Label styling
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .tertiaryLabel

        // Stack for text labels
        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            timeLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4

        // Horizontal stack for icon and text
        let hStack = UIStackView(arrangedSubviews: [
            iconView,
            textStack
        ])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        // Auto layout constraints
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configure Cell

    // Populates the cell with notification data
    func configure(with notification: StudentNotification) {

        // Set icon and color based on notification type
        iconView.image = notification.type.icon
        iconView.tintColor = notification.type.color

        // Set text values
        titleLabel.text = notification.type.title
        subtitleLabel.text = notification.subtitle

        // Convert date to readable "time ago" format
        timeLabel.text = notification.date.timeAgoDisplay()
    }
}
