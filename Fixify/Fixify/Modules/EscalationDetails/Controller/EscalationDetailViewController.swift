import UIKit

final class EscalationDetailViewController: UIViewController {

    private let service = LocalRequestService.shared

    private var request: Request
    private var technicianReassigned = false
    private var selectedPriority: String?

    private let priorities = ["Low", "Medium", "High"]
    private let picker = UIPickerView()

    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    private let technicianLabel = UILabel()

    private let priorityField = UITextField()
    private let reassignButton = UIButton(type: .system)
    private let updateButton = UIButton(type: .system)

    init(request: Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        title = "Escalation Details"
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        picker.delegate = self
        picker.dataSource = self
        priorityField.inputView = picker

        setupUI()
        populate()
    }

    private func setupUI() {

        titleLabel.font = .boldSystemFont(ofSize: 18)

        priorityField.borderStyle = .roundedRect
        priorityField.placeholder = "Select Priority"

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

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            dateLabel,
            technicianLabel,
            priorityField,
            reassignButton,
            updateButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func populate() {
        titleLabel.text = request.title
        locationLabel.text = request.location
        dateLabel.text = DateFormatter.localizedString(
            from: request.dateCreated,
            dateStyle: .medium,
            timeStyle: .none
        )
        technicianLabel.text = "Technician: \(request.assignedTechnicianID ?? "Unassigned")"
        priorityField.text = request.priority
    }

    @objc private func reassignTapped() {

        let vc = AssignTechnicianViewController(requestID: request.id)

        vc.onAssigned = { [weak self] techID in
            guard let self else { return }
            self.request.assignedTechnicianID = techID
            self.request.status = .assigned
            self.technicianReassigned = true
            self.technicianLabel.text = "Technician: \(techID)"
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func updateTapped() {

        guard technicianReassigned else {
            let alert = UIAlertController(
                title: "No Changes",
                message: "Reassign a technician before updating.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        var updatedRequest = request
        if let priority = selectedPriority {
            updatedRequest.priority = priority
        }

        service.updateRequest(updatedRequest)

        let alert = UIAlertController(
            title: "Success",
            message: "Request updated successfully ✅",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension EscalationDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        priorities.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        priorities[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        selectedPriority = priorities[row]
        priorityField.text = priorities[row]
    }
}
