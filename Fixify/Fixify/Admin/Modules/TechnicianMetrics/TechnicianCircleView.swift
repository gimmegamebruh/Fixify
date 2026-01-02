import UIKit

final class TechnicianCircleView: UIView {

    var onSelect: (() -> Void)?

    private let button = UIButton(type: .system)
    private let nameLabel = UILabel()

    init(technician: Technician, isSelected: Bool) {
        super.init(frame: .zero)
        setupUI(name: technician.name, selected: isSelected)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI(name: String, selected: Bool) {

        let imageName = selected
            ? "person.crop.circle.fill"
            : "person.crop.circle"

        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = selected ? .systemBlue : .label
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        nameLabel.text = name.components(separatedBy: " ").first
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [button, nameLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func tapped() {
        onSelect?()
    }
}
