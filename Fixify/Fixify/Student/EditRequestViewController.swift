import UIKit
import PhotosUI

final class EditRequestViewController: UIViewController {

    // MARK: - Dependencies
    private let store = RequestStore.shared
    private let requestID: String
    private var request: Request!
    private var selectedImage: UIImage?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()
    private let descriptionView = UITextView()

    private let photoView = UIImageView()
    private let changePhotoButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

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

    // MARK: - Init
    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Request"

        loadRequest()
        setupUI()
        setupPickers()
        populateFields()
    }

    // MARK: - Load
    private func loadRequest() {
        guard let req = store.requests.first(where: { $0.id == requestID }) else {
            navigationController?.popViewController(animated: true)
            return
        }

        // ❌ Safety: student can edit ONLY pending
        guard req.status == .pending else {
            navigationController?.popViewController(animated: true)
            return
        }

        request = req
    }

    // MARK: - UI
    private func setupUI() {
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

        configure(titleField, "Title")
        configure(locationField, "Location")
        configure(priorityField, "Select Priority")
        configure(categoryField, "Select Category")

        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 12
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)

        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        [
            titleField,
            locationField,
            priorityField,
            categoryField,
            descriptionView,
            photoView,
            changePhotoButton,
            saveButton
        ].forEach { stack.addArrangedSubview($0) }
    }

    // MARK: - Pickers
    private func setupPickers() {
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        priorityField.inputView = priorityPicker
        categoryField.inputView = categoryPicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        ]

        priorityField.inputAccessoryView = toolbar
        categoryField.inputAccessoryView = toolbar
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    // MARK: - Populate
    private func populateFields() {
        titleField.text = request.title
        locationField.text = request.location
        priorityField.text = request.priority.rawValue.capitalized
        categoryField.text = request.category
        descriptionView.text = request.description

        if let urlString = request.imageURL,
           let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    // MARK: - Actions
    @objc private func changePhotoTapped() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func saveTapped() {

        guard
            let title = titleField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty,
            let location = locationField.text?.trimmingCharacters(in: .whitespaces), !location.isEmpty,
            let priorityText = priorityField.text,
            let category = categoryField.text,
            !descriptionView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        let priority = RequestPriority(rawValue: priorityText.lowercased()) ?? .low

        func update(imageURL: String?) {
            var updated = request!
            updated.title = title
            updated.location = location
            updated.priority = priority
            updated.category = category
            updated.description = descriptionView.text
            updated.imageURL = imageURL

            store.updateRequest(updated)
            navigationController?.popViewController(animated: true)
        }

        if let image = selectedImage {
            CloudinaryUploadService.shared.upload(image: image) { url in
                DispatchQueue.main.async {
                    update(imageURL: url)
                }
            }
        } else {
            update(imageURL: request.imageURL)
        }
    }

    private func configure(_ tf: UITextField, _ placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
    }
}

// MARK: - Picker Delegates
extension EditRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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

// MARK: - Photo Picker
extension EditRequestViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { image, _ in
            guard let img = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.photoView.image = img
                self.selectedImage = img
            }
        }
    }
}
