import UIKit

final class EscalatedRequestCard: UIView {

    var onViewTap: (() -> Void)?

    private let badge = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let viewButton = UIButton(type: .system)

    init(request: Request) {
        super.init(frame: .zero)

        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        badge.font = .systemFont(ofSize: 12, weight: .semibold)
        badge.textColor = .white
        badge.textAlignment = .center
        badge.layer.cornerRadius = 8
        badge.layer.masksToBounds = true

        let daysOld = Calendar.current.dateComponents(
            [.day],
            from: request.dateCreated,
            to: Date()
        ).day ?? 0

        if daysOld > 5 {
            badge.text = "Overdue"
            badge.backgroundColor = .systemRed
        } else if request.priority.lowercased() == "high" {
            badge.text = "Urgent"
            badge.backgroundColor = .systemOrange
        } else {
            badge.isHidden = true
        }

        titleLabel.text = request.title
        titleLabel.font = .boldSystemFont(ofSize: 16)

        subtitleLabel.text = request.location
        subtitleLabel.textColor = .darkGray

        let f = DateFormatter()
        f.dateStyle = .medium
        dateLabel.text = f.string(from: request.dateCreated)
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 13)

        viewButton.setTitle("View", for: .normal)
        viewButton.setTitleColor(.white, for: .normal)
        viewButton.backgroundColor = .systemBlue
        viewButton.layer.cornerRadius = 10
        viewButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)

        let leftStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            dateLabel
        ])
        leftStack.axis = .vertical
        leftStack.spacing = 6

        let topRow = UIStackView(arrangedSubviews: [
            leftStack,
            badge
        ])
        topRow.alignment = .top
        topRow.spacing = 8

        let mainStack = UIStackView(arrangedSubviews: [
            topRow,
            viewButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            badge.widthAnchor.constraint(equalToConstant: 80),
            badge.heightAnchor.constraint(equalToConstant: 26),

            viewButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func viewTapped() {
        onViewTap?()
    }

    required init?(coder: NSCoder) { fatalError() }
}
