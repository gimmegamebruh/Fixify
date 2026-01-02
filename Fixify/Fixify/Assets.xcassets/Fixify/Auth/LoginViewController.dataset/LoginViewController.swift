import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LoginViewController: UIViewController {

    // MARK: - UI
    private let container = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {

        // Container (centers content on iPad)
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            container.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 420)
        ])

        // Logo
        logoImageView.image = UIImage(named: "fixify_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true


        // Subtitle
        subtitleLabel.text = "Maintenance made simple"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        // Email
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        // Password
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        // Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 12
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        // Stack
        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            titleLabel,
            subtitleLabel,
            UIView(), // spacer
            emailField,
            passwordField,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }

    // MARK: - Login
    @objc private func loginTapped() {

        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert("Error", "Email and password required")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showAlert("Login Failed", error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }
            self.fetchUserRole(uid: uid)
        }
    }

    private func fetchUserRole(uid: String) {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, _ in

                guard
                    let data = snapshot?.data(),
                    let roleString = data["role"] as? String
                else {
                    self.showAlert("Error", "User role not found")
                    return
                }

                let role: UserRole = roleString == "technician" ? .technician :
                                    roleString == "admin" ? .admin : .student

                DispatchQueue.main.async {
                    SceneDelegate.switchToRole(role)
                }
            }
    }
    
    private func fetchUserProfile(uid: String) {

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                if let error = error {
                    self.showAlert("Error", error.localizedDescription)
                    return
                }

                guard let data = snapshot?.data() else {
                    self.showAlert("Error", "User profile not found")
                    return
                }

                // ✅ Save everything to CurrentUser
                CurrentUser.id = uid
                CurrentUser.email = data["email"] as? String
                CurrentUser.name = data["name"] as? String
                CurrentUser.studentId = data["studentId"] as? String
                CurrentUser.technicianID = data["technicianID"] as? String
                CurrentUser.profileImageURL = data["profileImageURL"] as? String

                let roleString = data["role"] as? String ?? "student"
                CurrentUser.role = UserRole(rawValue: roleString) ?? .student

                DispatchQueue.main.async {
                    SceneDelegate.switchToRole(CurrentUser.role)
                }
            }
    }


    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

