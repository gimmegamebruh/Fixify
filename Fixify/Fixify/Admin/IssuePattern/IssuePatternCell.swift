//
//  IssuePatternCell.swift
//  Fixify
//
//  Created by BP-36-212-12 on 29/12/2025.
//


import UIKit

final class IssuePatternCell: UITableViewCell {

    static let identifier = "IssuePatternCell"

    private let card = UIView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let rankBadge = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Card
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 14
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        // Rank badge
        rankBadge.font = .systemFont(ofSize: 13, weight: .bold)
        rankBadge.textAlignment = .center
        rankBadge.textColor = .white
        rankBadge.backgroundColor = .systemBlue
        rankBadge.layer.cornerRadius = 14
        rankBadge.clipsToBounds = true
        rankBadge.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        // Count
        countLabel.font = .systemFont(ofSize: 14)
        countLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            countLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 6

        let hStack = UIStackView(arrangedSubviews: [
            rankBadge,
            textStack
        ])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            rankBadge.widthAnchor.constraint(equalToConstant: 28),
            rankBadge.heightAnchor.constraint(equalToConstant: 28),

            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
    }

    func configure(
        title: String,
        count: Int,
        rank: Int
    ) {
        titleLabel.text = title
        countLabel.text = "\(count) requests"
        rankBadge.text = "\(rank)"

        // Highlight top 3
        if rank == 1 {
            rankBadge.backgroundColor = .systemRed
        } else if rank == 2 {
            rankBadge.backgroundColor = .systemOrange
        } else if rank == 3 {
            rankBadge.backgroundColor = .systemYellow
        } else {
            rankBadge.backgroundColor = .systemBlue
        }
    }
}
