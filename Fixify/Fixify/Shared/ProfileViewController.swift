import UIKit

final class ProfileViewController: UIViewController {

    private let titleLabel = UILabel()
    private let roleLabel = UILabel()
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Profile"

        setupUI()
        configureForRole()
    }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center

        roleLabel.font = .systemFont(ofSize: 16)
        roleLabel.textColor = .secondaryLabel
        roleLabel.textAlignment = .center

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.tintColor = .systemRed
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            roleLabel,
            logoutButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureForRole() {
        titleLabel.text = "Fixify User"

        switch CurrentUser.role {
        case .student:
            roleLabel.text = "Role: Student"
        case .technician:
            roleLabel.text = "Role: Technician"
        case .admin:
            roleLabel.text = "Role: Admin"
        }
    }

    @objc private func logoutTapped() {
        SceneDelegate.switchToLogin()
    }
}

