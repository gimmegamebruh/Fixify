import UIKit

final class SettingsViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case general
        case support
        case preference
        case privacy

        var title: String {
            switch self {
            case .general: return "General"
            case .support: return "Support & About"
            case .preference: return "App Preference"
            case .privacy: return "Privacy"
            }
        }
    }

    private enum Row {
        case appVersion
        case faq
        case terms
        case contact
        case darkMode
        case privacyPolicy

        var title: String {
            switch self {
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

    private let sections: [[Row]] = [
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
        setupAppearance()
    }
    
    // MARK: - Setup Methods
    
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
        navigationController.navigationBar.tintColor = .systemGroupedBackground // Button color
        
        // Update view background to match
        view.backgroundColor = .label
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
        
        // Update switch colors
        sender.onTintColor = .systemGreen
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
            
            toggle.onTintColor = .systemGreen
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
        
        case .appVersion:
            print("App Version")
        case .faq:
            print("Navigate to FAQ")
        case .terms:
            print("Navigate to Terms of Service")
        case .contact:
            print("Navigate to Contact Information")
        case .privacyPolicy:
            print("Navigate to Privacy Policy")
        default:
            break
        }
    }
}
