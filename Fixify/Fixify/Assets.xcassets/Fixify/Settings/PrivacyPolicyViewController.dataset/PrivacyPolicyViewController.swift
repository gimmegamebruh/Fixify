import UIKit

final class PrivacyPolicyViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        setupNavigationBar()
        setupUI()
        setupContent()
    }
    
    private func setupNavigationBar() {
        // Back button with dynamic color
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = dynamicBackgroundColor()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: dynamicTextColor(),
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicTextColor()
        
        view.backgroundColor = dynamicBackgroundColor()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Apply dynamic colors
        contentLabel.textColor = dynamicTextColor()
    }
    
    private func setupContent() {
        let privacyText = """
1. Information We Collect
We may collect the following types of information:

• Personal Information: Name, email address, phone number, and profile details you provide when creating an account.

• Usage Data: Information such as device type, operating system, IP address, and actions performed within the App.

• Ticket & Repair Data: Details about issues you report, uploaded images, assigned technicians, and status updates.

• Location Data: If enabled, we may collect your device location to assign technicians or improve service accuracy.

2. How We Use Your Information
We use the collected data to:

• Provide and maintain the App's services.

• Process repair requests and assign technicians.

• Communicate updates, notifications, and support.

• Improve user experience and analyze usage patterns.

• Comply with legal obligations.

3. Data Sharing
We do not sell or rent your personal information. We may share data with:

• Service Providers: Third-party vendors who assist in app operations (e.g., cloud hosting, analytics).

• Technicians: Relevant information to fulfill repair requests.

• Legal Requirements: When required by law or to protect our rights.

4. Data Security
We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure.

5. Your Rights
You have the right to:

• Access, update, or delete your personal information.

• Opt-out of certain data collection (e.g., location tracking).

• Request a copy of your data.

6. Changes to This Policy
We may update this Privacy Policy from time to time. Continued use of the App after changes constitutes acceptance of the updated policy.

7. Contact Us
If you have any questions or concerns about this Privacy Policy, please contact us at:

Email: support@repairapp.com
Phone: +1 (555) 123-4567
"""
        
        contentLabel.text = privacyText
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .systemGray
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
