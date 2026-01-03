import UIKit
import PhotosUI

// This view controller allows the student to create a new maintenance request
// The student fills the form, selects priority/category, and can upload one photo
final class NewRequestViewController: UIViewController {

    // MARK: - Dependencies

    // Shared store used to save the new request
    private let store = RequestStore.shared

    // MARK: - UI Elements

    // Scroll view to allow scrolling when content is long
    private let scrollView = UIScrollView()

    // Stack view to arrange all UI elements vertically
    private let stack = UIStackView()

    // Input fields
    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()
    private let descriptionView = UITextView()

    // Photo related UI
    private let addPhotoButton = UIButton(type: .system)
    private let photosScroll = UIScrollView()
    private let photosStack = UIStackView()

    // Submit button
    private let submitButton = UIButton(type: .system)

    // MARK: - Image Data

    // Stores the selected image from photo picker
    private var selectedImage: UIImage?

    // MARK: - Picker Data

    // Available priorities
    private let priorities = ["Low", "Medium", "High", "Urgent"]

    // Available categories
    private let categories = [
        "AC Issue",
        "Electrical",
        "Plumbing",
        "Furniture",
        "Network",
        "Other"
    ]

    // Picker views
    private let priorityPicker = UIPickerView()
    private let categoryPicker = UIPickerView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Basic screen setup
        view.backgroundColor = .systemBackground
        title = "New Request"

        // Setup UI and layout
        setupScroll()
        setupFields()
        setupPickers()
        setupLayout()

        // Set default picker values to avoid empty selection
        setDefaultPickerValues()
    }

    // MARK: - Default Values

    // Sets default values for priority and category
    private func setDefaultPickerValues() {
        priorityField.text = priorities.first
        categoryField.text = categories.first
    }

    // MARK: - Scroll Setup

    // Configures scroll view and stack view
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    // MARK: - Field Setup

    // Configures all text fields, buttons, and photo preview area
    private func setupFields() {

        configureTextField(titleField, "Title")
        configureTextField(locationField, "Location")
        configureTextField(priorityField, "Select Priority")
        configureTextField(categoryField, "Select Category")

        // Description text view styling
        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        // Add photo button
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.contentHorizontalAlignment = .leading
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)

        // Horizontal scroll for image preview
        photosScroll.heightAnchor.constraint(equalToConstant: 140).isActive = true
        photosScroll.showsHorizontalScrollIndicator = false

        photosStack.axis = .horizontal
        photosStack.spacing = 10
        photosStack.translatesAutoresizingMaskIntoConstraints = false
        photosScroll.addSubview(photosStack)

        NSLayoutConstraint.activate([
            photosStack.topAnchor.constraint(equalTo: photosScroll.topAnchor),
            photosStack.bottomAnchor.constraint(equalTo: photosScroll.bottomAnchor),
            photosStack.leadingAnchor.constraint(equalTo: photosScroll.leadingAnchor, constant: 8),
            photosStack.trailingAnchor.constraint(equalTo: photosScroll.trailingAnchor, constant: -8),
            photosStack.heightAnchor.constraint(equalTo: photosScroll.heightAnchor)
        ])

        // Submit button styling
        submitButton.setTitle("Submit Request", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 10
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    // MARK: - Picker Setup

    // Setup picker views for priority and category
    private func setupPickers() {
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        priorityField.inputView = priorityPicker
        categoryField.inputView = categoryPicker

        priorityField.inputAccessoryView = pickerToolbar()
        categoryField.inputAccessoryView = pickerToolbar()
    }

    // Toolbar with Done button for pickers
    private func pickerToolbar() -> UIToolbar {
        let tb = UIToolbar()
        tb.sizeToFit()
        tb.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        ]
        return tb
    }

    // Closes picker
    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    // MARK: - Layout

    // Adds all UI elements to stack view
    private func setupLayout() {
        [
            titleField,
            locationField,
            priorityField,
            categoryField,
            addPhotoButton,
            photosScroll,
            descriptionView,
            submitButton
        ].forEach { stack.addArrangedSubview($0) }
    }

    // MARK: - Helper Methods

    // Simple helper to configure text fields
    private func configureTextField(_ tf: UITextField, _ placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
    }

    // Shows alert message to the user
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Missing Info",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Submit Request

    // Called when submit button is tapped
    @objc private func submitTapped() {

        // Get current logged-in user ID
        guard let userID = CurrentUser.resolvedUserID() else {
            showAlert("User not logged in.")
            return
        }

        // Validate all required fields
        guard
            let title = titleField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty,
            let location = locationField.text?.trimmingCharacters(in: .whitespaces), !location.isEmpty,
            let priorityText = priorityField.text, !priorityText.isEmpty,
            let category = categoryField.text, !category.isEmpty,
            !descriptionView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            showAlert("Please fill all fields correctly.")
            return
        }

        let requestID = UUID().uuidString
        let priority = RequestPriority(rawValue: priorityText.lowercased()) ?? .low

        // Creates and saves the request
        func createRequest(imageURL: String?) {
            let request = Request(
                id: requestID,
                title: title,
                description: descriptionView.text,
                location: location,
                category: category,
                priority: priority,
                status: .pending,
                createdBy: userID,
                assignedTechnicianID: nil,
                assignmentSource: nil,
                assignedByUserID: nil,
                dateCreated: Date(),
                scheduledTime: nil,
                rating: nil,
                ratingComment: nil,
                imageURL: imageURL
            )

            store.add(request)
            self.navigationController?.popViewController(animated: true)
        }

        // Upload image if user selected one
        if let image = selectedImage {
            CloudinaryUploadService.shared.upload(image: image) { url in
                DispatchQueue.main.async {
                    createRequest(imageURL: url)
                }
            }
        } else {
            createRequest(imageURL: nil)
        }
    }

    // MARK: - Photo Selection

    // Opens photo picker
    @objc private func addPhotoTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Photo Preview

    // Shows selected photo in scroll view
    private func updatePhotoPreview(_ image: UIImage) {

        // Remove previous images
        photosStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 140)
        ])

        photosStack.addArrangedSubview(imageView)
    }
}

// MARK: - Picker Delegates

extension NewRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        pickerView == priorityPicker ? priorities.count : categories.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        pickerView == priorityPicker ? priorities[row] : categories[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == priorityPicker {
            priorityField.text = priorities[row]
        } else {
            categoryField.text = categories[row]
        }
    }
}

// MARK: - Photo Picker Delegate

extension NewRequestViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { image, _ in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.selectedImage = image
                self.updatePhotoPreview(image)
            }
        }
    }
}
