import UIKit
import PhotosUI

// This screen allows the student to edit an existing maintenance request
// Student can only edit requests that are still pending
final class EditRequestViewController: UIViewController {

    // MARK: - Dependencies

    // Shared store that holds all requests
    private let store = RequestStore.shared

    // ID of the request that we want to edit
    private let requestID: String

    // The actual request object (loaded using the ID)
    private var request: Request!

    // Stores the new selected image if student changes it
    private var selectedImage: UIImage?

    // MARK: - UI Elements

    // Scroll view to allow scrolling when content is long
    private let scrollView = UIScrollView()

    // Stack view to arrange UI elements vertically
    private let stack = UIStackView()

    // Text fields for request details
    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()

    // Text view for description (multi-line text)
    private let descriptionView = UITextView()

    // Image view to show request photo
    private let photoView = UIImageView()

    // Button to change the photo
    private let changePhotoButton = UIButton(type: .system)

    // Button to save changes
    private let saveButton = UIButton(type: .system)

    // MARK: - Picker Data

    // Priority options for picker
    private let priorities = ["Low", "Medium", "High", "Urgent"]

    // Category options for picker
    private let categories = [
        "AC Issue",
        "Electrical",
        "Plumbing",
        "Furniture",
        "Network",
        "Other"
    ]

    // Picker views for priority and category
    private let priorityPicker = UIPickerView()
    private let categoryPicker = UIPickerView()

    // MARK: - Initializer

    // Custom initializer that receives request ID
    init(requestID: String) {
        self.requestID = requestID
        super.init(nibName: nil, bundle: nil)
    }

    // Required initializer (not used)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background color
        view.backgroundColor = .systemBackground
        title = "Edit Request"

        // Load request data
        loadRequest()

        // Setup UI and pickers
        setupUI()
        setupPickers()

        // Fill fields with existing request data
        populateFields()
    }

    // MARK: - Load Request

    // Loads the request using the provided ID
    private func loadRequest() {

        // Find the request from the store
        guard let req = store.requests.first(where: { $0.id == requestID }) else {
            // If not found, go back
            navigationController?.popViewController(animated: true)
            return
        }

        // Safety rule: student can only edit pending requests
        guard req.status == .pending else {
            navigationController?.popViewController(animated: true)
            return
        }

        request = req
    }

    // MARK: - UI Setup

    // Creates and layouts all UI elements
    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        // Auto layout constraints
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

        // Configure text fields
        configure(titleField, "Title")
        configure(locationField, "Location")
        configure(priorityField, "Select Priority")
        configure(categoryField, "Select Category")

        // Description styling
        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        // Image styling
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 12
        photoView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        // Change photo button
        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)

        // Save button
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        // Add all elements to stack view
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

    // MARK: - Picker Setup

    // Setup pickers for priority and category
    private func setupPickers() {

        priorityPicker.delegate = self
        priorityPicker.dataSource = self

        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        // Assign pickers to text fields
        priorityField.inputView = priorityPicker
        categoryField.inputView = categoryPicker

        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        ]

        priorit
