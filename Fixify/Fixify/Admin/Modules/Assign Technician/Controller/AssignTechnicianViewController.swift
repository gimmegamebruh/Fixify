import UIKit

final class AssignTechnicianViewController: UIViewController {

    private let viewModel: AssignTechnicianViewModel
    private let tableView = UITableView()

    init(requestID: String) {
        self.viewModel = AssignTechnicianViewModel(requestID: requestID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Assign Technician"
        view.backgroundColor = .systemGroupedBackground

        setupTableView()

        // Bind reload callback
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        //  Load data
        viewModel.load()
    }

    // MARK: - Table Setup

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

    // MARK: - Error

    private func showError(_ msg: String) {
        let alert = UIAlertController(
            title: "Error",
            message: msg,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AssignTechnicianViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
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
            isCurrentlyAssigned: viewModel.isCurrentlyAssigned(technician)
        )

        cell.onAssignTapped = { [weak self] in
            guard let self else { return }

            self.viewModel.assignTechnician(technician) { success in
                DispatchQueue.main.async {
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showError(
                            "Technician could not be assigned. Request may be locked."
                        )
                    }
                }
            }
        }

        return cell
    }
}
