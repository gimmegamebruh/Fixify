//
//  StatCardView.swift
//  Fixify
//
//  Created by BP-36-213-03 on 15/12/2025.
//


import UIKit

final class StatCardView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String, value: String, highlighted: Bool = false) {
        super.init(frame: .zero)

        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        heightAnchor.constraint(equalToConstant: 90).isActive = true

        

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1

        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 22)
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 1

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }


    required init?(coder: NSCoder) { fatalError() }
}
