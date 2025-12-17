import UIKit

final class LoginViewController: UIViewController {

    private let email = UITextField()
    private let password = UITextField()
    private let role = UISegmentedControl(items: ["Student", "Tech", "Admin"])
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"

        email.placeholder = "Email"
        email.borderStyle = .roundedRect
        password.placeholder = "Password"
        password.borderStyle = .roundedRect
        password.isSecureTextEntry = true

        role.selectedSegmentIndex = 0

        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(login), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [email, password, role, button])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func login() {
        let selected: UserRole = role.selectedSegmentIndex == 0 ? .student :
                                 role.selectedSegmentIndex == 1 ? .technician : .admin
        SceneDelegate.switchToRole(selected)
    }
}

