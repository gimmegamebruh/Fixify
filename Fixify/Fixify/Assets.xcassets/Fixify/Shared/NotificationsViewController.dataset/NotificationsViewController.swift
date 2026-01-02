import UIKit

final class NotificationsViewController: UIViewController {

    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notifications"

        setupUI()
        configureForRole()
    }

    private func setupUI() {
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func configureForRole() {
        switch CurrentUser.role {
        case .student:
            label.text = "You’ll receive updates about your requests here."
        case .technician:
            label.text = "Job updates and assignments will appear here."
        case .admin:
            label.text = "System alerts and administrative notifications."
        }
    }
}

