import UIKit

final class EditProfileViewController: UIViewController {
    
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
    
    // Profile Picture Section
    private let profilePictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Picture :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // Contact Number Section
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Number :"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "12345678"
        textField.text = "12345678"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // Address Section
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address (Street, Building, Block):"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "675, 7578, 602"
        textField.text = "675, 7578, 602"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // Emergency Contact Section
    private let emergencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Emergency Contact Number:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emergencyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "45368522"
        textField.text = "45368522"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // Confirm Button
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Edits", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
        
        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        // Back button with dynamic color
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = dynamicTextColor()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Custom centered title label
        let titleLabel = UILabel()
        titleLabel.text = "Edit Profile"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = dynamicTextColor()
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Navigation bar appearance
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
        
        contentView.addSubview(profilePictureLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(contactLabel)
        contentView.addSubview(contactTextField)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressTextField)
        contentView.addSubview(emergencyLabel)
        contentView.addSubview(emergencyTextField)
        contentView.addSubview(confirmButton)
        
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
            
            // Profile Picture Label
            profilePictureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profilePictureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Profile Image
            profileImageView.centerYAnchor.constraint(equalTo: profilePictureLabel.centerYAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Contact Label
            contactLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            contactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Contact TextField
            contactTextField.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 12),
            contactTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Address Label
            addressLabel.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 24),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Address TextField
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Emergency Label
            emergencyLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 24),
            emergencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emergencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Emergency TextField
            emergencyTextField.topAnchor.constraint(equalTo: emergencyLabel.bottomAnchor, constant: 12),
            emergencyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emergencyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emergencyTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm Button
            confirmButton.topAnchor.constraint(equalTo: emergencyTextField.bottomAnchor, constant: 60),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
            confirmButton.heightAnchor.constraint(equalToConstant: 44),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Apply dynamic colors
        profilePictureLabel.textColor = dynamicTextColor()
        contactLabel.textColor = dynamicTextColor()
        addressLabel.textColor = dynamicTextColor()
        emergencyLabel.textColor = dynamicTextColor()
        
        // Update text field colors for dark mode
        contactTextField.backgroundColor = dynamicTextFieldBackgroundColor()
        contactTextField.textColor = dynamicTextColor()
        addressTextField.backgroundColor = dynamicTextFieldBackgroundColor()
        addressTextField.textColor = dynamicTextColor()
        emergencyTextField.backgroundColor = dynamicTextFieldBackgroundColor()
        emergencyTextField.textColor = dynamicTextColor()
    }
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        // Validate and save changes
        guard let contact = contactTextField.text, !contact.isEmpty else {
            showAlert(message: "Please enter a contact number")
            return
        }
        
        guard let address = addressTextField.text, !address.isEmpty else {
            showAlert(message: "Please enter an address")
            return
        }
        
        guard let emergency = emergencyTextField.text, !emergency.isEmpty else {
            showAlert(message: "Please enter an emergency contact number")
            return
        }
        
        // Save the data (you can use UserDefaults, Core Data, or send to server)
        UserDefaults.standard.set(contact, forKey: "userContact")
        UserDefaults.standard.set(address, forKey: "userAddress")
        UserDefaults.standard.set(emergency, forKey: "userEmergency")
        
        showAlert(message: "Profile updated successfully!") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func profileImageTapped() {
        // Show image picker
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose an option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    private func openCamera() {
        // Implement camera functionality
        print("Open Camera")
    }
    
    private func openPhotoLibrary() {
        // Implement photo library functionality
        print("Open Photo Library")
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
    
    private func dynamicTextFieldBackgroundColor() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .darkGray : .white
        }
    }
}
