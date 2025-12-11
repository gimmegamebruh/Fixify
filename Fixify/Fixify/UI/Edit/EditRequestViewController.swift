
import UIKit

class EditRequestViewController: UIViewController {

    private let store = RequestStore.shared
    private let index: Int

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let titleField = UITextField()
    private let locationField = UITextField()
    private let priorityField = UITextField()
    private let categoryField = UITextField()
    private let descriptionView = UITextView()
    private let saveButton = UIButton(type: .system)

    init(requestIndex: Int) {
        self.index = requestIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Edit Request"

        setupScroll()
        setupFields()
        setupLayout()
        loadData()
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

        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        stack.addArrangedSubview(titleField)
        stack.addArrangedSubview(locationField)
        stack.addArrangedSubview(priorityField)
        stack.addArrangedSubview(categoryField)
        stack.addArrangedSubview(descriptionView)
        stack.addArrangedSubview(saveButton)
    }

    private func loadData() {
        let request = store.request(at: index)
        titleField.text = request.title
        locationField.text = request.location
        priorityField.text = request.priority
        categoryField.text = request.category
        descriptionView.text = request.description
    }

    @objc private func saveTapped() {
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

        var updated = store.request(at: index)
        updated.title = title
        updated.location = location
        updated.priority = priority
        updated.category = category
        updated.description = descriptionView.text

        store.update(at: index, with: updated)
        navigationController?.popViewController(animated: true)
    }
}
