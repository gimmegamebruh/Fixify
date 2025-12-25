import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SettingsViewController: UIViewController {

    private var currentUserID: String?
    private let db = Firestore.firestore()

    private enum Section: Int, CaseIterable {
        case account
        case general
        case support
        case preference
        case privacy

        var title: String {
            switch self {
            case .account: return "Account"
            case .general: return "General"
            case .support: return "Support & About"
            case .preference: return "App Preference"
            case .privacy: return "Privacy"
            }
        }
    }

    private enum Row {
        case viewProfile
        case editProfile
        case logout
        case appVersion
        case faq
        case terms
        case contact
        case darkMode
        case privacyPolicy

        var title: String {
            switch self {
            case .viewProfile: return "View Full Profile"
            case .editProfile: return "Edit Profile"
            case .logout: return "Logout"
            case .appVersion: return "App Version"
            case .faq: return "FAQ"
            case .terms: return "Terms of Service"
            case .contact: return "Contact Information"
            case .darkMode: return "Dark Mode"
            case .privacyPolicy: return "Privacy Policy"
            }
        }
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // Profile Header Container
    private let profileHeaderContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sections: [[Row]] = [
        [.viewProfile,.editProfile,.logout],
        [.appVersion],
        [.faq, .terms, .contact],
        [.darkMode],
        [.privacyPolicy]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        view.backgroundColor = .systemBackground
        
        // Apply saved dark mode preference on app launch
        applySavedDarkModePreference()
        
        setupTableView()
        setupProfileHeader()
        setupAppearance()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        loadUserData()
    }
    
    // MARK: - Setup Methods
    
    private func applySavedDarkModePreference() {
        // Check if user has ever set a preference
        let hasSetPreference = UserDefaults.standard.object(forKey: "isDarkModeEnabled") != nil
        
        if hasSetPreference {
            let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
            let style: UIUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = style
                }
            }
        } else {
            // First time - set to system default (unspecified) and save as OFF
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
            UserDefaults.standard.set(false, forKey: "isDarkModeEnabled")
        }
    }
    
    private func setupProfileHeader() {
        profileHeaderContainer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        
        profileHeaderContainer.addSubview(profileImageView)
        profileHeaderContainer.addSubview(nameLabel)
        profileHeaderContainer.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: profileHeaderContainer.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: profileHeaderContainer.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileHeaderContainer.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12),
            
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
        
        tableView.tableHeaderView = profileHeaderContainer
        nameLabel.textColor = dynamicTextColor()
        emailLabel.textColor = UIColor.systemGray
    }
    
    private func setupAppearance() {
        guard let navigationController = self.navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGroupedBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .label
        
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Load User Data
    
    private func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in")
            return
        }
        
        currentUserID = user.uid
        
        let userEmail = user.email ?? "No email"
        emailLabel.text = userEmail
        
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                
                DispatchQueue.main.async {
                    if let name = data?["name"] as? String {
                        self.nameLabel.text = name
                    }
                    
                    // Load profile image if URL exists, otherwise keep default
                    if let imageURL = data?["profileImageURL"] as? String, !imageURL.isEmpty {
                        self.loadProfileImage(from: imageURL)
                    } else {
                        // No image in Firebase - set to default
                        self.profileImageView.image = UIImage(systemName: "person.crop.circle")
                        self.profileImageView.tintColor = .systemGray3
                    }
                }
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.profileImageView.image = image
                } else {
                    // If image loading fails, show default
                    self.profileImageView.image = UIImage(systemName: "person.crop.circle")
                    self.profileImageView.tintColor = .systemGray3
                }
            }
        }.resume()
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }

    // MARK: - Actions
    
    @objc private func darkModeChanged(_ sender: UISwitch) {
        let newStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = newStyle
            }
        }
        
        setupAppearance()
        
        sender.onTintColor = sender.isOn ? .black : .systemGreen
        sender.thumbTintColor = .white
        
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
    }
    
    // MARK: - Logout Functionality
    
    private func handleLogout() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        do {
            try Auth.auth().signOut()
            CurrentUser.clear()
            
            // Reset dark mode to OFF when logging out
            UserDefaults.standard.set(false, forKey: "isDarkModeEnabled")
            
            // Reset app appearance to system default
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
            
            DispatchQueue.main.async {
                self.navigateToLogin()
            }
            
        } catch let error {
            print("Error logging out: \(error.localizedDescription)")
            showLogoutErrorAlert()
        }
    }
    
    private func navigateToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        window.rootViewController = navController
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    private func showLogoutErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to logout. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let row = sections[indexPath.section][indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        var content = cell.defaultContentConfiguration()
        content.text = row.title
        cell.contentConfiguration = content

        cell.selectionStyle = .default
        cell.accessoryView = nil
        cell.accessoryType = .none

        switch row {

        case .appVersion:
            content.secondaryText = "1.03"
            cell.contentConfiguration = content
            cell.accessoryType = .none
            cell.selectionStyle = .none

        case .darkMode:
            let toggle = UISwitch()
            
            // Always default to OFF unless user explicitly turned it ON
            let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
            toggle.isOn = isDarkModeEnabled
            
            toggle.onTintColor = isDarkModeEnabled ? .black : .systemGreen
            toggle.thumbTintColor = .white
            
            toggle.addTarget(self, action: #selector(darkModeChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none
            
        case .logout:
            content.textProperties.color = .systemRed
            cell.contentConfiguration = content
            cell.accessoryType = .none

        default:
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = sections[indexPath.section][indexPath.row]

        switch row {
        case .viewProfile:
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .editProfile:
            let editProfileVC = EditProfileViewController()
            navigationController?.pushViewController(editProfileVC, animated: true)
            
        case .logout:
            handleLogout()
            
        case .appVersion:
            print("App Version")
            
        case .faq:
            let faqVC = FAQViewController()
            navigationController?.pushViewController(faqVC, animated: true)
            
        case .terms:
            let termsVC = Term_ServiceViewController()
            navigationController?.pushViewController(termsVC, animated: true)
            
        case .contact:
            let contactVC = ContactViewController()
            navigationController?.pushViewController(contactVC, animated: true)
            
        case .privacyPolicy:
            let privacyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyVC, animated: true)
            
        default:
            break
        }
    }
}
