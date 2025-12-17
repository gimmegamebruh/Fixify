import UIKit

final class ChatListViewController: UIViewController {

    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Chat"

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
            label.text = "Chat with your assigned technician."
        case .technician:
            label.text = "Chat with students regarding their requests."
        case .admin:
            label.text = "Administrative chat (optional)."
        }
    }
}

