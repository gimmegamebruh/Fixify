import UIKit
import PhotosUI

final class EditRequestViewController: UIViewController {

    private let store = RequestStore.shared
    private let requestID: String
    private var request: Request!
    private var selectedImage: UIImage?

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

    // MARK: - Init
    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Request"

        loadRequest()
        setupUI()
        populateFields()
    }

    private func loadRequest() {
        guard let req = store.requests.first(where: { $0.id == requestID }) else {
            navigationController?.popViewController(animated: true)
            return
        }
        request = req
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        configure(titleField, "Title")
        configure(locationField, "Location")
        configure(priorityField, "Priority (Low / Medium / High)")
        configure(categoryField, "Category")

        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 8
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)

        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        stack.addArrangedSubview(titleField)
        stack.addArrangedSubview(locationField)
        stack.addArrangedSubview(priorityField)
        stack.addArrangedSubview(categoryField)
        stack.addArrangedSubview(descriptionView)
        stack.addArrangedSubview(photoView)
        stack.addArrangedSubview(changePhotoButton)
        stack.addArrangedSubview(saveButton)
    }

    private func configure(_ tf: UITextField, _ placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
    }

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

    @objc private func changePhotoTapped() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func saveTapped() {

        let priority = RequestPriority(
            rawValue: priorityField.text?.lowercased() ?? "low"
        ) ?? .low

        func update(imageURL: String?) {
            var updated = request!
            updated.title = titleField.text ?? ""
            updated.description = descriptionView.text
            updated.location = locationField.text ?? ""
            updated.category = categoryField.text ?? ""
            updated.priority = priority
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

}

// MARK: - Image Picker
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

