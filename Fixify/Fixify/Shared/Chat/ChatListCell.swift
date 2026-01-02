//
//  ChatListCell.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class ChatListCell: UITableViewCell {

    static let reuseID = "ChatListCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusBadge = PaddingLabel()
    private let container = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with request: Request) {
        titleLabel.text = request.title
        subtitleLabel.text = request.location

        statusBadge.text = request.status.rawValue.capitalized
        statusBadge.backgroundColor = request.status.color.withAlphaComponent(0.15)
        statusBadge.textColor = request.status.color
    }

    private func setupUI() {
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        statusBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        statusBadge.textAlignment = .center
        statusBadge.layer.cornerRadius = 6
        statusBadge.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            statusBadge
        ])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
}
