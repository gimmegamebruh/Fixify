import UIKit

class NewRequestViewController: UIViewController {

    private let store = RequestStore.shared
    private let currentStudentID = "student123"

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()
    private let descriptionView = UITextView()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "New Request"

        setupScroll()
        setupFields()
        setupLayout()
    }

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 12
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

    private func configureTextField(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
    }

    private func setupFields() {
        configureTextField(titleField, placeholder: "Title")
        configureTextField(locationField, placeholder: "Location")
        configureTextField(priorityField, placeholder: "Priority (e.g. High)")
        configureTextField(categoryField, placeholder: "Category (e.g. AC Issue)")

        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.cornerRadius = 8
        descriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        submitButton.setTitle("Submit Request", for: .normal)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        submitButton.backgroundColor = .systemBlue
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 10
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        stack.addArrangedSubview(titleField)
        stack.addArrangedSubview(locationField)
        stack.addArrangedSubview(priorityField)
        stack.addArrangedSubview(categoryField)
        stack.addArrangedSubview(descriptionView)
        stack.addArrangedSubview(submitButton)
    }

    @objc private func submitTapped() {
        guard
            let title = titleField.text, !title.isEmpty,
            let location = locationField.text, !location.isEmpty,
            let priority = priorityField.text, !priority.isEmpty,
            let category = categoryField.text, !category.isEmpty,
            !descriptionView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            let alert = UIAlertController(title: "Missing Info",
                                          message: "Please fill all fields.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let newRequest = Request(
            id: UUID(),
            title: title,
            location: location,
            priority: priority,
            category: category,
            description: descriptionView.text,
            status: .pending,
            dateCreated: Date(),
            createdBy: currentStudentID
        )

        store.add(newRequest)
        navigationController?.popViewController(animated: true)
    }
}

