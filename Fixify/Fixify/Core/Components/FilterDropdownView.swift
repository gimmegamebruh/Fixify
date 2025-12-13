//
//  FilterDropdownView.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import UIKit

class FilterDropdownView: UIView {

    var onSelectFilter: ((RequestFilter) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.2

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        RequestFilter.allCases.forEach { filter in
            let btn = UIButton(type: .system)
            btn.setTitle(filter.rawValue, for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.addAction(UIAction { [weak self] _ in
                self?.onSelectFilter?(filter)
            }, for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}
