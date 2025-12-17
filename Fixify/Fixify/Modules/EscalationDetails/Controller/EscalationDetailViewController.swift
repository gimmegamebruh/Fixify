import UIKit

final class EscalationDetailViewController: UIViewController {

    // MARK: - Dependencies
    private let requestService: RequestServicing = LocalRequestService.shared

    // MARK: - State
    private var request: Request
    private let priorityOptions = ["Low", "Medium", "High"]
    private var selectedPriority: String?

    // MARK: - UI
    private let infoCard = UIView()
    private let infoLabel = UILabel()

    private let statusLabel = UILabel()
    private let priorityField = UITextField()

    private let reassignButton = UIButton(type: .system)
    private let updateButton = UIButton(type: .system)

    // MARK: - Init
    init(request: Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        title = "Escalation Details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {

        // ---------- Info Card ----------
        infoCard.backgroundColor = .white
        infoCard.layer.cornerRadius = 14
        infoCard.layer.shadowOpacity = 0.08
        infoCard.layer.shadowRadius = 6
        infoCard.layer.shadowOffset = CGSize(width: 0, height: 3)

        infoLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.text = """
        \(request.title) – \(request.location)
        \(formattedDate(request.dateCreated))
        Technician: \(request.assignedTechnicianID ?? "Unassigned")
        """

        infoCard.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16)
        ])

        // ---------- Status ----------
        statusLabel.text = escalationStatusText()
        statusLabel.textColor = .systemRed
        statusLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        // ---------- Priority ----------
        priorityField.placeholder = "Select Priority"
        priorityField.borderStyle = .roundedRect
        priorityField.inputView = makePicker()

        // ---------- Buttons ----------
        reassignButton.setTitle("Reassign Technician", for: .normal)
        reassignButton.backgroundColor = .systemBlue
        reassignButton.setTitleColor(.white, for: .normal)
        reassignButton.layer.cornerRadius = 14
        reassignButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reassignButton.addTarget(self, action: #selector(reassignTapped), for: .touchUpInside)

        updateButton.setTitle("Update", for: .normal)
        updateButton.layer.borderWidth = 1
        updateButton.layer.borderColor = UIColor.systemBlue.cgColor
        updateButton.layer.cornerRadius = 14
        updateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)

        // ---------- Stack ----------
        let stack = UIStackView(arrangedSubviews: [
            infoCard,
            statusLabel,
            priorityField,
            reassignButton,
            updateButton
        ])

        stack.axis = .vertical
        stack.spacing = 20

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    @objc private func reassignTapped() {
        let vc = AssignTechnicianViewController(requestID: request.id)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func updateTapped() {
        guard let priority = selectedPriority else {
            showAlert("Please select priority")
            return
        }

        // Update through service (SOURCE OF TRUTH)
        var updated = request
        updated.priority = priority

        requestService.updateRequest(updated)

        request = updated
        showAlert("Data Updated Successfully ✅")
    }

    // MARK: - Helpers
    private func makePicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }

    private func escalationStatusText() -> String {
        request.priority == "High" ? "Overdue" : "Escalated"
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Picker
extension EscalationDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        priorityOptions.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        priorityOptions[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        selectedPriority = priorityOptions[row]
        priorityField.text = priorityOptions[row]
    }
}
