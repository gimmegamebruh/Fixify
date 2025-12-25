//
//  AdminNotificationCell.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class AdminNotificationCell: UITableViewCell {

    static let reuseID = "AdminNotificationCell"

    private let card = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        card.dsCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .tertiaryLabel

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            timeLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [
            iconView,
            textStack
        ])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

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

    func configure(with notification: AdminNotification) {
        iconView.image = notification.type.icon
        iconView.tintColor = notification.type.color

        titleLabel.text = notification.type.title
        subtitleLabel.text = notification.subtitle
        timeLabel.text = notification.date.timeAgoDisplay()
    }
}
