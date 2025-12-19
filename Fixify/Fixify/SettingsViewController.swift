import UIKit

final class SettingsViewController: UIViewController {

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
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "john.doe@student.com"
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
        setupTableView()
        setupProfileHeader()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupProfileHeader() {
        // Set the frame for the header container
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
        
        // Set the header view
        tableView.tableHeaderView = profileHeaderContainer
        
        // Apply dynamic colors to labels
        nameLabel.textColor = dynamicTextColor()
        emailLabel.textColor = UIColor.systemGray
    }
    
    private func setupAppearance() {
        guard let navigationController = self.navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        
        // Use systemGroupedBackground to match the insetGrouped table view style
        appearance.backgroundColor = .systemGroupedBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        // Use dynamic color for title text
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .label
        
        // Update view background to match
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
    
    // MARK: - Dynamic Colors
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }

    // MARK: - Actions
    
    @objc private func darkModeChanged(_ sender: UISwitch) {
        let newStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        // Change the interface style for the entire app
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = newStyle
            }
        }
        
        // Refresh the navigation bar appearance after the style change
        setupAppearance()
        
        // Update switch colors based on dark mode state
        sender.onTintColor = sender.isOn ? .black : .systemGreen
        sender.thumbTintColor = .white
        
        // Save the preference
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
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
        // Use dequeuing with the registered cell identifier for efficiency
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
            
            // Restore saved preference or use current system style
            let savedDarkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
            toggle.isOn = savedDarkMode
            
            toggle.onTintColor = savedDarkMode ? .black : .systemGreen
            toggle.thumbTintColor = .white
            
            toggle.addTarget(self, action: #selector(darkModeChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none

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
            print("Logout")
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
