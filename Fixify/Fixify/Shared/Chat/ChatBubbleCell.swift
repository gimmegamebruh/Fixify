//
//  ChatBubbleCell.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class ChatBubbleCell: UITableViewCell {

    static let reuseID = "ChatBubbleCell"

    private let bubble = UIView()
    private let messageLabel = UILabel()

    private var leading: NSLayoutConstraint!
    private var trailing: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        bubble.layer.cornerRadius = 16
        messageLabel.numberOfLines = 0

        bubble.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bubble)
        bubble.addSubview(messageLabel)

        leading = bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailing = bubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubble.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),

            messageLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with message: ChatMessage) {
        let isMe = message.senderId == CurrentUser.id

        messageLabel.text = message.text
        messageLabel.textColor = isMe ? .white : .label
        bubble.backgroundColor = isMe ? .systemBlue : .systemGray5

        leading.isActive = !isMe
        trailing.isActive = isMe
    }
}
