import UIKit
import FirebaseAuth
import FirebaseFirestore

final class ProfileViewController: UIViewController {
    
    private var currentUserID: String?
    private let db = Firestore.firestore()
    
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
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Stack view for better layout management
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let studentIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let emergencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // Empty state view for when no data is available
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No profile information available.\nPlease complete your profile."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = dynamicTextColor()
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = dynamicBackgroundColor()
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicTextColor()
        
        view.backgroundColor = dynamicBackgroundColor()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(infoCardView)
        
        // Add stack view to info card
        infoCardView.addSubview(infoStackView)
        infoCardView.addSubview(emptyStateLabel)
        
        // Add all labels to stack view
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(studentIdLabel)
        infoStackView.addArrangedSubview(emailLabel)
        infoStackView.addArrangedSubview(contactLabel)
        infoStackView.addArrangedSubview(addressLabel)
        infoStackView.addArrangedSubview(emergencyLabel)
        
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
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoCardView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            infoStackView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 24),
            infoStackView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -24),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: infoCardView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: infoCardView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -20)
        ])
        
        // Apply dynamic colors
        applyDynamicColors()
        
        // Initially hide all labels
        hideAllLabels()
    }
    
    private func applyDynamicColors() {
        nameLabel.textColor = dynamicTextColor()
        studentIdLabel.textColor = dynamicTextColor()
        emailLabel.textColor = dynamicTextColor()
        contactLabel.textColor = dynamicTextColor()
        addressLabel.textColor = dynamicTextColor()
        emergencyLabel.textColor = dynamicTextColor()
        infoCardView.backgroundColor = dynamicCardBackgroundColor()
    }
    
    private func hideAllLabels() {
        nameLabel.isHidden = true
        studentIdLabel.isHidden = true
        emailLabel.isHidden = true
        contactLabel.isHidden = true
        addressLabel.isHidden = true
        emergencyLabel.isHidden = true
    }
    
    // MARK: - Load User Data
    
    private func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "No user logged in")
            return
        }
        
        currentUserID = user.uid
        
        // Hide all labels first
        hideAllLabels()
        var hasData = false
        
        // Load email from Auth
        if let userEmail = user.email, !userEmail.isEmpty {
            emailLabel.text = "Email: \(userEmail)"
            emailLabel.isHidden = false
            hasData = true
        }
        
        // Load additional data from Firestore
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading user data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showEmptyState()
                }
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                var firestoreHasData = false
                
                DispatchQueue.main.async {
                    // Update UI with Firestore data - only show labels with data
                    if let name = data?["name"] as? String, !name.isEmpty {
                        self.nameLabel.text = "Name: \(name)"
                        self.nameLabel.isHidden = false
                        firestoreHasData = true
                    }
                    
                    if let studentId = data?["studentId"] as? String, !studentId.isEmpty {
                        self.studentIdLabel.text = "Student ID: \(studentId)"
                        self.studentIdLabel.isHidden = false
                        firestoreHasData = true
                    }
                    
                    if let contact = data?["contactNumber"] as? String, !contact.isEmpty {
                        self.contactLabel.text = "Contact Number: \(contact)"
                        self.contactLabel.isHidden = false
                        firestoreHasData = true
                    }
                    
                    if let address = data?["address"] as? String, !address.isEmpty {
                        self.addressLabel.text = "Address: \(address)"
                        self.addressLabel.isHidden = false
                        firestoreHasData = true
                    }
                    
                    if let emergency = data?["emergencyContact"] as? String, !emergency.isEmpty {
                        self.emergencyLabel.text = "Emergency Contact: \(emergency)"
                        self.emergencyLabel.isHidden = false
                        firestoreHasData = true
                    }
                    
                    // Load profile image if URL exists
                    if let imageURL = data?["profileImageURL"] as? String, !imageURL.isEmpty {
                        self.loadProfileImage(from: imageURL)
                    }
                    
                    // Show empty state if no data at all (including email)
                    if !hasData && !firestoreHasData {
                        self.showEmptyState()
                    } else {
                        self.emptyStateLabel.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    // Only show empty state if email also doesn't exist
                    if !hasData {
                        self.showEmptyState()
                    } else {
                        self.emptyStateLabel.isHidden = true
                    }
                }
            }
        }
    }
    
    private func showEmptyState() {
        emptyStateLabel.isHidden = false
        infoStackView.isHidden = true
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Show loading indicator on image
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: profileImageView.bounds.midX, y: profileImageView.bounds.midY)
        activityIndicator.tag = 999
        profileImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Remove loading indicator
                if let indicator = self.profileImageView.viewWithTag(999) as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
                
                if let data = data, error == nil, let image = UIImage(data: data) {
                    self.profileImageView.image = image
                } else {
                    // Keep default icon if loading fails
                    print("Error loading profile image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }.resume()
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Dynamic Colors
    
    private func dynamicBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .systemGray6
        }
    }
    
    private func dynamicTextColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    private func dynamicCardBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .darkGray : .white
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
