import UIKit

final class AssignTechnicianViewController: UIViewController {

    // MARK: - Callback
    var onAssigned: ((String) -> Void)?

    private let viewModel: AssignTechnicianViewModel
    private let tableView = UITableView()

    private let overlay = UIView()
    private let popup = UIView()

    init(requestID: String) {
        self.viewModel = AssignTechnicianViewModel(requestID: requestID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Assign Technician"
        view.backgroundColor = .systemGroupedBackground

        setupTableView()
        setupPopup()

        viewModel.loadDummyData()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.register(
            TechnicianCell.self,
            forCellReuseIdentifier: TechnicianCell.identifier
        )
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Popup

    private func setupPopup() {

        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.alpha = 0

        popup.backgroundColor = .white
        popup.layer.cornerRadius = 16
        popup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        let label = UILabel()
        label.text = "Technician Assigned\nSuccessfully ✅"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        let okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .systemBlue
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [label, okButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        popup.addSubview(stack)
        overlay.addSubview(popup)
        view.addSubview(overlay)

        overlay.translatesAutoresizingMaskIntoConstraints = false
        popup.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            popup.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            popup.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            popup.widthAnchor.constraint(equalToConstant: 260),

            stack.topAnchor.constraint(equalTo: popup.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -24),

            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func showPopup() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5) {
            self.overlay.alpha = 1
            self.popup.transform = .identity
        }
    }

    @objc private func dismissPopup() {

        if let techID = viewModel.assignedTechnicianID {
            onAssigned?(techID)
        }

        UIView.animate(withDuration: 0.2) {
            self.overlay.alpha = 0
        } completion: { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AssignTechnicianViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.technicians.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianCell.identifier,
            for: indexPath
        ) as! TechnicianCell

        let tech = viewModel.technicians[indexPath.row]

        cell.configure(
            with: tech,
            isAssigned: viewModel.isAssigned(tech.id)
        )

        cell.assignButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.assignTechnician(tech.id)
            self?.tableView.reloadData()
            self?.showPopup()
        }, for: .touchUpInside)

        return cell
    }
}
