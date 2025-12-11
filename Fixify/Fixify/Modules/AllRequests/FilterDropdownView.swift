import UIKit

class FilterDropdownView: UIView {

    var onSelectFilter: ((RequestFilter) -> Void)?

    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        stack.axis = .vertical
        stack.spacing = 12
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
            btn.setTitleColor(.black, for: .normal)
            btn.contentHorizontalAlignment = .left

            btn.addAction(UIAction(handler: { [weak self] _ in
                self?.onSelectFilter?(filter)
            }), for: .touchUpInside)

            stack.addArrangedSubview(btn)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
