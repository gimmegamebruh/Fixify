import UIKit

final class AssignTechnicianViewController: UIViewController {

    private let viewModel: AssignTechnicianViewModel
    private let tableView = UITableView()

    // Selection-only mode (used by EscalationDetail)
    private let onTechnicianSelected: ((Technician) -> Void)?

    // Normal assignment mode
    init(requestID: String) {
        self.viewModel = AssignTechnicianViewModel(requestID: requestID)
        self.onTechnicianSelected = nil
        super.init(nibName: nil, bundle: nil)
    }

    // Selection-only mode
    init(onTechnicianSelected: @escaping (Technician) -> Void) {
        self.viewModel = AssignTechnicianViewModel(requestID: "SELECTION_MODE")
        self.onTechnicianSelected = onTechnicianSelected
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assign Technician"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        viewModel.load()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.register(
            TechnicianCell.self,
            forCellReuseIdentifier: TechnicianCell.identifier
        )
        tableView.dataSource = self
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Success Alert
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Technician assigned successfully ✅",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension AssignTechnicianViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.technicians.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianCell.identifier,
            for: indexPath
        ) as! TechnicianCell

        let technician = viewModel.technician(at: indexPath.row)

        cell.configure(
            with: technician,
            isBusy: viewModel.isBusy(technician)
        )

        cell.onAssignTapped = { [weak self] in
            guard let self else { return }

            // 🔹 Selection-only mode (Escalation Detail)
            if let onTechnicianSelected = self.onTechnicianSelected {
                onTechnicianSelected(technician)
                self.navigationController?.popViewController(animated: true)
                return
            }

            // 🔹 Normal assignment flow
            self.viewModel.assignTechnician(technician) { success in
                if success {
                    DispatchQueue.main.async {
                        self.showSuccessAlert()
                    }
                }
            }
        }

        return cell
    }
}
