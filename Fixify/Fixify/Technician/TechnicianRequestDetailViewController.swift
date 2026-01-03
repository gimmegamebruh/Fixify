import UIKit

final class TechnicianRequestDetailViewController: UIViewController {

    private let store = RequestStore.shared
    private var request: Request

    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let statusBadge = PaddingLabel()
    private let descriptionLabel = UILabel()
    private let locationLabel = UILabel()
    private let assignmentLabel = UILabel()
    private let warningLabel = UILabel()
    private let priorityLabel = PaddingLabel()
    private let dateLabel = UILabel()
    private let photoView = UIImageView()
    private let assignButton = UIButton(type: .system)
    private let scheduleButton = UIButton(type: .system)
    private let chatButton = UIButton(type: .system)
    private var imageTask: URLSessionDataTask?

    init(request: Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        title = "Request \(request.id)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        refreshUI()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        statusBadge.font = .systemFont(ofSize: 13, weight: .semibold)
        statusBadge.layer.cornerRadius = 6
        statusBadge.clipsToBounds = true
        statusBadge.textAlignment = .center

        assignmentLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        assignmentLabel.textColor = .secondaryLabel
        assignmentLabel.numberOfLines = 0

        warningLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        warningLabel.textColor = .systemRed
        warningLabel.numberOfLines = 0
        warningLabel.isHidden = true

        priorityLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        priorityLabel.layer.cornerRadius = 6
        priorityLabel.clipsToBounds = true
        priorityLabel.textAlignment = .center

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)

        locationLabel.font = .systemFont(ofSize: 15, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 12
        photoView.backgroundColor = .secondarySystemBackground
        photoView.heightAnchor.constraint(equalToConstant: 220).isActive = true

        assignButton.setTitle("Assign to Me", for: .normal)
        assignButton.backgroundColor = .systemBlue
        assignButton.tintColor = .white
        assignButton.layer.cornerRadius = 10
        assignButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        assignButton.addTarget(self, action: #selector(assignToMe), for: .touchUpInside)

        scheduleButton.setTitle("Schedule", for: .normal)
        scheduleButton.backgroundColor = .systemOrange
        scheduleButton.tintColor = .white
        scheduleButton.layer.cornerRadius = 10
        scheduleButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        scheduleButton.addTarget(self, action: #selector(scheduleJob), for: .touchUpInside)

        chatButton.setTitle("Open Chat", for: .normal)
        chatButton.backgroundColor = .systemPurple
        chatButton.tintColor = .white
        chatButton.layer.cornerRadius = 10
        chatButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        chatButton.addTarget(self, action: #selector(openChat), for: .touchUpInside)

        let actions = UIStackView(arrangedSubviews: [
            assignButton,
            scheduleButton,
            makeActionButton(title: "Mark In Progress", color: .systemBlue, selector: #selector(markActive)),
            makeActionButton(title: "Mark Completed", color: .systemGreen, selector: #selector(markCompleted)),
            chatButton
        ])
        actions.axis = .vertical
        actions.spacing = 10

        let fields: [UIView] = [
            statusBadge,
            priorityLabel,
            locationLabel,
            dateLabel,
            assignmentLabel,
            warningLabel,
            photoView,
            descriptionLabel,
            actions
        ]
        fields.forEach { stack.addArrangedSubview($0) }

        scrollView.addSubview(stack)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func refreshUI() {
        statusBadge.text = request.status.rawValue.capitalized
        statusBadge.backgroundColor = request.status.color.withAlphaComponent(0.15)
        statusBadge.textColor = request.status.color

        priorityLabel.text = "Priority: \(request.priority.rawValue.capitalized)"
        priorityLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        priorityLabel.textColor = .systemOrange

        locationLabel.text = "Location: \(request.location)"

        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        dateLabel.text = "Submitted: \(df.string(from: request.dateCreated))"

        let descriptionText = request.description.isEmpty ? "No additional details." : request.description
        descriptionLabel.text = "Details:\n\(descriptionText)"

        let assignedText: String
        let sourceText: String
        if CurrentUser.role == .technician,
           let techID = CurrentUser.resolvedUserID(),
           let assignedID = request.assignedTechnicianID {
            assignedText = assignedID == techID ? "Assigned to you" : "Assigned to another technician"
            let source = request.effectiveAssignmentSource
            sourceText = source == .technician ? "You self-assigned this request." : "Assignment set by admin."
        } else if request.assignedTechnicianID == nil {
            assignedText = "Not assigned"
            sourceText = "No assignment yet."
        } else {
            assignedText = "Assigned"
            sourceText = "Assignment set by admin."
        }
        var techInfo = ""
        if request.status == .active, let assignedID = request.assignedTechnicianID {
            techInfo = "\nAssigned technician ID: \(assignedID)"
        }
        assignmentLabel.text = "\(assignedText)\n\(sourceText)\(techInfo)"

        warningLabel.isHidden = true

        imageTask?.cancel()
        photoView.image = nil
        photoView.isHidden = request.imageURL == nil
        if let urlString = request.imageURL,
           let url = URL(string: urlString) {
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let self else { return }
                DispatchQueue.main.async {
                    self.photoView.image = UIImage(data: data)
                }
            }
            imageTask?.resume()
        }

        updateAssignmentUI()
    }

    private func makeActionButton(title: String, color: UIColor, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }

    @objc private func markActive() {
        updateStatus(.active)
        showAlert(title: "Status Updated", message: "Request marked as active.")
    }

    @objc private func markCompleted() {
        // Navigate to products screen without updating status yet
        let productsVC = ProductsUsedViewController(requestId: request.id)
        
        // Set completion handler to update status after products are handled
        productsVC.onJobCompleted = { [weak self] in
            guard let self = self else { return }
            self.updateStatus(.completed)
        }
        
        navigationController?.pushViewController(productsVC, animated: true)
    }

    @objc private func assignToMe() {
        guard CurrentUser.role == .technician else {
            showAlert(title: "Wrong Role", message: "Only technicians can assign requests.")
            return
        }
        guard let techID = CurrentUser.resolvedUserID() else {
            showAlert(title: "Missing Technician", message: "No user ID available.")
            return
        }

        if let currentAssignee = request.assignedTechnicianID {
            if currentAssignee != techID {
                showAlert(title: "Already Assigned", message: "This request is owned by another technician.")
                return
            }

            if request.effectiveAssignmentSource == .technician {
                request.assignedTechnicianID = nil
                request.assignmentSource = nil
                request.assignedByUserID = nil
                request.scheduledTime = nil
                request.status = .pending
                store.updateRequest(request)
                NotificationCenter.default.post(name: .technicianRequestsDidChange, object: nil)
                refreshUI()
                showAlert(title: "Unassigned", message: "You removed yourself from this request.")
            } else {
                showAlert(title: "Assignment Locked", message: "An admin assigned this request. Contact admin to change it.")
            }
            return
        }

        request.assignedTechnicianID = techID
        request.assignmentSource = .technician
        request.assignedByUserID = techID
        request.status = .assigned
        store.updateRequest(request)
        NotificationCenter.default.post(name: .technicianRequestsDidChange, object: nil)
        showAlert(title: "Assigned", message: "This job is now assigned to you.")
        refreshUI()
    }

    @objc private func scheduleJob() {
        guard let techID = CurrentUser.resolvedUserID() else {
            showAlert(title: "Missing Technician", message: "No user ID available.")
            return
        }
        guard CurrentUser.role == .technician else {
            showAlert(title: "Wrong Role", message: "Only technicians can schedule requests.")
            return
        }

        if request.assignedTechnicianID != techID {
            showAlert(title: "Assign first", message: "Assign the job to yourself to schedule it.")
            return
        }

        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .wheels

        let alert = UIAlertController(title: "Schedule Job", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 8),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -8),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.heightAnchor.constraint(equalToConstant: 240)
        ])

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.request.scheduledTime = picker.date
            self.store.updateRequest(self.request)
            NotificationCenter.default.post(name: .technicianRequestsDidChange, object: nil)
            self.refreshUI()
            self.showAlert(title: "Scheduled", message: "Job scheduled for \(self.formatted(date: picker.date)).")
        }))

        present(alert, animated: true)
    }

    private func updateStatus(_ status: RequestStatus) {
        guard request.status != status else { return }
        request.status = status
        store.updateStatus(id: request.id, status: status)
        NotificationCenter.default.post(name: .technicianRequestsDidChange, object: nil)
        refreshUI()
    }

    @objc private func openChat() {
        let chatVC = ChatViewController(requestID: request.id)
        navigationController?.pushViewController(chatVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func formatted(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }

    private func updateAssignmentUI() {
        let techID = CurrentUser.userID
        let assignedToCurrent = techID != nil && request.assignedTechnicianID == techID
        let assignedToOther = request.assignedTechnicianID != nil && !assignedToCurrent

        warningLabel.isHidden = !assignedToOther
        warningLabel.text = "Assigned to another technician. You cannot take it."

        assignButton.isEnabled = !assignedToOther
        assignButton.backgroundColor = assignedToCurrent ? .systemRed : (assignedToOther ? .systemGray4 : .systemBlue)
        assignButton.setTitle(assignedToCurrent ? "Unassign" : "Assign to Me", for: .normal)

        scheduleButton.isEnabled = assignedToCurrent
        scheduleButton.alpha = assignedToCurrent ? 1 : 0.5
    }
}
