import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class EditProfileViewController: UIViewController {
    
    private var currentUserID: String?
    private let db = Firestore.firestore()
    private var selectedImage: UIImage?
    private var shouldRemovePhoto = false
    private var hadProfileImage = false // Track if user had a photo when view loaded
    
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
        textField.placeholder = "Contact Number"
        textField.text = ""
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
        textField.placeholder = "Street, Building, Block"
        textField.text = ""
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
        textField.placeholder = "Emergency Contact Number"
        textField.text = ""
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
        loadUserData()
        
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
    
    // MARK: - Load User Data
    
    private func loadUserData() {
        guard let user = Auth.auth().currentUser else { return }
        
        currentUserID = user.uid
        
        // Load data from Firestore
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                
                DispatchQueue.main.async {
                    // Update UI with user data
                    self.contactTextField.text = data?["contactNumber"] as? String ?? ""
                    self.addressTextField.text = data?["address"] as? String ?? ""
                    self.emergencyTextField.text = data?["emergencyContact"] as? String ?? ""
                    
                    // Load profile image if URL exists
                    if let imageURL = data?["profileImageURL"] as? String {
                        self.loadProfileImage(from: imageURL)
                        self.hadProfileImage = true
                    }
                }
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.profileImageView.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        // Validate input
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
        
        // Check if profile image is set (not default icon and not removed)
        let isDefaultImage = profileImageView.image == UIImage(systemName: "person.crop.circle")
        if isDefaultImage && selectedImage == nil && !hadProfileImage {
            showAlert(message: "Please select a profile picture")
            return
        }
        
        guard let userID = currentUserID else {
            showAlert(message: "User not authenticated")
            return
        }
        
        // Show loading indicator
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        confirmButton.isEnabled = false
        
        // Check if user wants to remove photo
        if shouldRemovePhoto {
            // Remove photo from Firebase
            saveUserData(userID: userID, contact: contact, address: address, emergency: emergency, imageURL: nil, removePhoto: true)
        } else if let image = selectedImage {
            // Upload new image
            uploadImageToCloudinary(image) { [weak self] imageURL in
                guard let self = self else { return }
                self.saveUserData(userID: userID, contact: contact, address: address, emergency: emergency, imageURL: imageURL, removePhoto: false)
            }
        } else {
            // Save without updating image
            saveUserData(userID: userID, contact: contact, address: address, emergency: emergency, imageURL: nil, removePhoto: false)
        }
    }
    
    private func uploadImageToCloudinary(_ image: UIImage, completion: @escaping (String?) -> Void) {
        CloudinaryUploadService.shared.upload(image: image) { imageURL in
            completion(imageURL)
        }
    }
    
    private func saveUserData(userID: String, contact: String, address: String, emergency: String, imageURL: String?, removePhoto: Bool) {
        var userData: [String: Any] = [
            "contactNumber": contact,
            "address": address,
            "emergencyContact": emergency,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        // Handle photo removal or update
        if removePhoto {
            userData["profileImageURL"] = FieldValue.delete()
        } else if let imageURL = imageURL {
            userData["profileImageURL"] = imageURL
        }
        
        // Save to Firestore
        db.collection("users").document(userID).setData(userData, merge: true) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Remove loading indicator
                if let loadingView = self.view.viewWithTag(999) {
                    loadingView.removeFromSuperview()
                }
                self.confirmButton.isEnabled = true
                
                if let error = error {
                    self.showAlert(message: "Error saving profile: \(error.localizedDescription)")
                } else {
                    self.showAlert(message: "Profile updated successfully!") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func profileImageTapped() {
        // Show image picker options
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose an option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        
        if profileImageView.image != UIImage(systemName: "person.crop.circle") {
            alert.addAction(UIAlertAction(title: "Remove Photo", style: .destructive) { [weak self] _ in
                self?.removeProfilePhoto()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad support
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = profileImageView
            popoverController.sourceRect = profileImageView.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func removeProfilePhoto() {
        let alert = UIAlertController(
            title: "Remove Photo",
            message: "This will remove your profile photo when you save.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Reset to default image
            self.profileImageView.image = UIImage(systemName: "person.crop.circle")
            self.profileImageView.tintColor = .systemGray3
            self.selectedImage = nil
            self.shouldRemovePhoto = true
        })
        
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
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(message: "Camera is not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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

// MARK: - UIImagePickerControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            profileImageView.image = editedImage
            shouldRemovePhoto = false
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            profileImageView.image = originalImage
            shouldRemovePhoto = false
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
