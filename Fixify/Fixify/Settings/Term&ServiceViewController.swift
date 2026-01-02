import UIKit

    final class Term_ServiceViewController: UIViewController {
        
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
            title = "Terms & Service"
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
    Last Updated: November 2025

    Welcome to our application. By accessing or using this app, you agree to the following Terms of Service. Please read them carefully. If you do not agree with any part of these terms, you may not use the app or its services.

    1. Acceptance of Terms
    By creating an account or using the app, you confirm that you are at least 16 years old and that you accept and agree to be bound by these Terms of Service and our Privacy Policy. Continued use of the app indicates your ongoing acceptance of any updates or modifications.

    2. Use of the Service
    The app allows users to create, manage, and track repair requests (“tickets”). You agree to use the service responsibly and only for lawful purposes. You must not misuse the app, interfere with its functionality, or attempt to access data that does not belong to you.
    Examples of prohibited activity include:
    Submitting false or misleading repair requests
    Attempting to disrupt the system or access restricted areas
    Uploading harmful or inappropriate content
    Using automated scripts or bots without permission
    Violating these rules may result in suspension or termination of your account.

    3. User Accounts
    To use certain features, you must create an account with accurate and up-to-date information. You are responsible for:
    Maintaining the confidentiality of your login credentials
    All activity that occurs under your account
    Promptly updating your information when it changes
    We reserve the right to suspend or deactivate accounts that violate the Terms or show suspicious activity.

    4. Submitting Repair Requests
    When you file a repair ticket, you agree that:
    All information provided is accurate and relevant
    Uploaded photos or videos relate directly to the issue
    You will not submit inappropriate, copyrighted, or harmful materials
    We may remove or reject tickets that violate these guidelines.

    5. Notifications and Communication
    By using the app, you agree to receive notifications about ticket updates, service announcements, and messages from technicians or support staff. You may adjust your notification settings at any time through the app.

    6. Service Availability
    While we strive to ensure continuous and reliable service, we do not guarantee the app will always be available or error-free. System interruptions, maintenance, or updates may occur. We are not responsible for delays, data loss, or service disruptions outside our control.

    7. Limitation of Liability
    To the fullest extent permitted by law, we are not liable for:
    Any damages resulting from your use or inability to use the app
    Loss of data, interruptions, delays, or system errors
    Interactions or disputes between you and technicians or service providers
    You use the app at your own risk. The service is provided “as is” and without any warranties beyond those required by law.

    8. Changes to the Terms
    We may update these Terms from time to time to reflect improvements, legal requirements, or changes in the service. When updates occur, we will post the new Terms within the app and update the “Last Updated” date. Continued use of the app after changes means you accept the revised Terms.

    9. Account Termination
    You may delete your account at any time through the Profile page. We may suspend or terminate accounts that violate these Terms, pose security concerns, or engage in fraudulent activity. Once terminated, access to your account and ticket history may be permanently removed.
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
