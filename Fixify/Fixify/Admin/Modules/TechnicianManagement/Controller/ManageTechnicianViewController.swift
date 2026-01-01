import UIKit
import FirebaseFirestore

final class ManageTechnicianViewController: UIViewController {

    // MARK: - Services
    private let technicianService: TechnicianServicing = FirebaseTechnicianService.shared
    private let db = Firestore.firestore()

    // MARK: - Data
    private var technicians: [Technician] = []
    private var selectedTechnician: Technician?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let techniciansScroll = UIScrollView()
    private let techniciansStack = UIStackView()

    private let contentCard = UIView()
    private let formStack = UIStackView()

    private let nameField = UITextField()
    private let emailField = UITextField()
    private let contactNumberField = UITextField()
    private let emergencyContactField = UITextField()
    private let addressField = UITextField()
    private let specializationField = UITextField()

    private let activeButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Technician Management"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTechnicianTapped)
        )

        setupScroll()
        setupTechniciansRow()
        setupContentCard()
        loadTechnicians()
    }

    // MARK: - Layout
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func setupTechniciansRow() {
        techniciansScroll.showsHorizontalScrollIndicator = false
        techniciansScroll.translatesAutoresizingMaskIntoConstraints = false
        techniciansScroll.heightAnchor.constraint(equalToConstant: 80).isActive = true

        techniciansStack.axis = .horizontal
        techniciansStack.spacing = 16
        techniciansStack.translatesAutoresizingMaskIntoConstraints = false

        techniciansScroll.addSubview(techniciansStack)

        NSLayoutConstraint.activate([
            techniciansStack.topAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.topAnchor),
            techniciansStack.bottomAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.bottomAnchor),
            techniciansStack.leadingAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.leadingAnchor, constant: 8),
            techniciansStack.trailingAnchor.constraint(equalTo: techniciansScroll.contentLayoutGuide.trailingAnchor, constant: -8),
            techniciansStack.heightAnchor.constraint(equalTo: techniciansScroll.frameLayoutGuide.heightAnchor)
        ])

        contentStack.addArrangedSubview(techniciansScroll)
    }

    private func setupContentCard() {
        contentCard.backgroundColor = .white
        contentCard.layer.cornerRadius = 14
        contentCard.layer.shadowOpacity = 0.08
        contentCard.layer.shadowRadius = 6

        formStack.axis = .vertical
        formStack.spacing = 14
        formStack.translatesAutoresizingMaskIntoConstraints = false

        contentCard.addSubview(formStack)

        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: contentCard.topAnchor, constant: 20),
            formStack.leadingAnchor.constraint(equalTo: contentCard.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: contentCard.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(equalTo: contentCard.bottomAnchor, constant: -20)
        ])

        setupFormFields()
        contentStack.addArrangedSubview(contentCard)
    }

    // MARK: - Form
    private func setupFormFields() {
        addField("Name", nameField)
        addField("Email", emailField)
        addField("Contact Number", contactNumberField)
        addField("Emergency Contact", emergencyContactField)
        addField("Address", addressField)
        addField("Specialization", specializationField)

        configureActiveButton()
        configureSaveButton()

        formStack.addArrangedSubview(activeButton)
        formStack.addArrangedSubview(saveButton)
    }

    private func addField(_ title: String, _ field: UITextField) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)

        field.borderStyle = .roundedRect
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true

        formStack.addArrangedSubview(label)
        formStack.addArrangedSubview(field)
    }

    private func configureActiveButton() {
        activeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        activeButton.layer.cornerRadius = 8
        activeButton.layer.borderWidth = 1
        activeButton.addTarget(self, action: #selector(toggleActive), for: .touchUpInside)
    }

    private func configureSaveButton() {
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
    }

    // MARK: - Data
    private func loadTechnicians() {
        technicianService.fetchAll { [weak self] techs in
            DispatchQueue.main.async {
                self?.technicians = techs
                self?.buildTechnicianCircles()
                if let first = techs.first {
                    self?.selectTechnician(first)
                }
            }
        }
    }

    private func buildTechnicianCircles() {
        techniciansStack.arrangedSubviews.forEach {
            techniciansStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        technicians.forEach { tech in
            let view = TechnicianCircleView(
                technician: tech,
                isSelected: tech.id == selectedTechnician?.id
            )
            view.onSelect = { [weak self] in
                self?.selectTechnician(tech)
            }
            techniciansStack.addArrangedSubview(view)
        }
    }

    private func selectTechnician(_ tech: Technician) {
        selectedTechnician = tech
        populateForm()
        buildTechnicianCircles()
    }

    private func populateForm() {
        guard let tech = selectedTechnician else { return }

        nameField.text = tech.name
        specializationField.text = tech.specialization
        updateActiveButton(isActive: tech.isActive)

        db.collection("users").document(tech.id).getDocument { [weak self] snap, _ in
            let data = snap?.data()
            self?.emailField.text = data?["email"] as? String
            self?.contactNumberField.text = data?["contactNumber"] as? String
            self?.emergencyContactField.text = data?["emergencyContact"] as? String
            self?.addressField.text = data?["address"] as? String
        }
    }

    private func updateActiveButton(isActive: Bool) {
        activeButton.setTitle(isActive ? "Deactivate Technician" : "Activate Technician", for: .normal)
        activeButton.setTitleColor(isActive ? .systemRed : .systemGreen, for: .normal)
        activeButton.layer.borderColor = (isActive ? UIColor.systemRed : UIColor.systemGreen).cgColor
    }

    // MARK: - Actions
    @objc private func toggleActive() {
        guard var tech = selectedTechnician else { return }
        tech.isActive.toggle()
        selectedTechnician = tech
        updateActiveButton(isActive: tech.isActive)
    }

    @objc private func saveChanges() {
        guard let tech = selectedTechnician else { return }

        let data: [String: Any] = [
            "name": nameField.text ?? "",
            "email": emailField.text ?? "",
            "contactNumber": contactNumberField.text ?? "",
            "emergencyContact": emergencyContactField.text ?? "",
            "address": addressField.text ?? "",
            "specialization": specializationField.text ?? "",
            "isActive": tech.isActive,
            "updatedAt": Timestamp(date: Date())
        ]

        db.collection("users")
            .document(tech.id)
            .updateData(data) { [weak self] error in
                DispatchQueue.main.async {
                    if let error {
                        self?.showAlert(
                            title: "Update Failed",
                            message: error.localizedDescription
                        )
                    } else {
                        self?.showAlert(
                            title: "Success",
                            message: "Technician updated successfully."
                        )
                    }
                }
            }
    }

    // MARK: - Add Technician
    @objc private func addTechnicianTapped() {
        let alert = UIAlertController(title: "Add Technician", message: nil, preferredStyle: .alert)

        let fields = [
            "Name",
            "Email",
            "Password",
            "Contact Number",
            "Emergency Contact",
            "Address",
            "Specialization"
        ]

        fields.forEach { placeholder in
            alert.addTextField { tf in
                tf.placeholder = placeholder
                if placeholder == "Password" { tf.isSecureTextEntry = true }
                if placeholder == "Email" { tf.keyboardType = .emailAddress }
                if placeholder.contains("Number") { tf.keyboardType = .phonePad }
            }
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard
                let self,
                let f = alert.textFields,
                let name = f[0].text,
                let email = f[1].text,
                let password = f[2].text,
                !name.isEmpty,
                !email.isEmpty,
                password.count >= 6
            else {
                self?.showAlert(
                    title: "Invalid Input",
                    message: "Please fill all required fields and use a valid password."
                )
                return
            }

            let extraData: [String: Any] = [
                "contactNumber": f[3].text ?? "",
                "emergencyContact": f[4].text ?? "",
                "address": f[5].text ?? ""
            ]

            self.technicianService.createTechnician(
                name: name,
                email: email,
                password: password,
                specialization: f[6].text ?? "",
                extraData: extraData
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tech):
                        self.showAlert(
                            title: "Success",
                            message: "Technician added successfully."
                        ) {
                            self.selectTechnician(tech)
                        }

                    case .failure(let error):
                        self.showAlert(
                            title: "Creation Failed",
                            message: error.localizedDescription
                        )
                    }
                }
            }
        })

        present(alert, animated: true)
    }

    // MARK: - Alert Helper
    private func showAlert(
        title: String,
        message: String,
        onDismiss: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onDismiss?()
        })
        present(alert, animated: true)
    }
}
