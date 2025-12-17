import UIKit
import PhotosUI

final class NewRequestViewController: UIViewController {

    // MARK: - Dependencies
    private let store = RequestStore.shared
    private let currentStudentID = "student123"

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()
    private let descriptionView = UITextView()

    private let addPhotoButton = UIButton(type: .system)
    private let photosScroll = UIScrollView()
    private let photosStack = UIStackView()

    private let submitButton = UIButton(type: .system)

    // MARK: - Image
    private var selectedImage: UIImage?

    // MARK: - Picker Data
    private let priorities = ["Low", "Medium", "High", "Urgent"]
    private let categories = [
        "AC Issue",
        "Electrical",
        "Plumbing",
        "Furniture",
        "Network",
        "Other"
    ]

    private let priorityPicker = UIPickerView()
    private let categoryPicker = UIPickerView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "New Request"

        setupScroll()
        setupFields()
        setupPickers()
        setupLayout()
    }

    // MARK: - Setup Scroll
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

    // MARK: - Setup Fields
    private func setupFields() {
        configureTextField(titleField, "Title")
        configureTextField(locationField, "Location")
        configureTextField(priorityField, "Select Priority")
        configureTextField(categoryField, "Select Category")

        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.contentHorizontalAlignment = .leading
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)

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

        submitButton.setTitle("Submit Request", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 10
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    // MARK: - Setup Pickers
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

    private func pickerToolbar() -> UIToolbar {
        let tb = UIToolbar()
        tb.sizeToFit()
        tb.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        ]
        return tb
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    // MARK: - Layout
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

    // MARK: - Helpers
    private func configureTextField(_ tf: UITextField, _ placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Missing Info",
            message: "Please fill all fields.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func updatePhotoPreview(_ image: UIImage) {
        photosStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.systemGray4.cgColor
        imgView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 140),
            imgView.heightAnchor.constraint(equalToConstant: 140)
        ])

        photosStack.addArrangedSubview(imgView)
    }

    // MARK: - Actions
    @objc private func submitTapped() {

        guard
            let title = titleField.text, !title.isEmpty,
            let location = locationField.text, !location.isEmpty,
            let priorityText = priorityField.text, !priorityText.isEmpty,
            let category = categoryField.text, !category.isEmpty,
            !descriptionView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            showAlert()
            return
        }

        let requestID = UUID().uuidString
        let priority = RequestPriority(rawValue: priorityText.lowercased()) ?? .low

        func createRequest(imageURL: String?) {
            let request = Request(
                id: requestID,
                title: title,
                description: descriptionView.text,
                location: location,
                category: category,
                priority: priority,
                status: .pending,
                createdBy: currentStudentID,
                assignedTo: nil,
                dateCreated: Date(),
                scheduledTime: nil,
                imageURL: imageURL
            )

            store.add(request)

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }

        // 🔥 ONE upload path only
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


    @objc private func addPhotoTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Pickers
extension NewRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == priorityPicker ? priorities.count : categories.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        pickerView == priorityPicker ? priorities[row] : categories[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        if pickerView == priorityPicker {
            priorityField.text = priorities[row]
        } else {
            categoryField.text = categories[row]
        }
    }
}

// MARK: - Photo Picker
extension NewRequestViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
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

