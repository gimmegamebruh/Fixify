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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assign Technician"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        viewModel.load()
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
            self?.viewModel.assignTechnician(technician) { success in
                if success {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }

        return cell
    }
}
