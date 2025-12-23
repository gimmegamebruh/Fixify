import UIKit

final class AssignTechnicianViewController: UIViewController {

    private let viewModel: AssignTechnicianViewModel
    private let tableView = UITableView()

    init(requestID: String) {
        self.viewModel = AssignTechnicianViewModel(requestID: requestID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Assign Technician"
        view.backgroundColor = .systemGroupedBackground

        setupTableView()

        // 🔥 load + reload table
        viewModel.load { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.register(TechnicianCell.self, forCellReuseIdentifier: TechnicianCell.identifier)
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

    private func showError(_ msg: String) {
        let a = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

extension AssignTechnicianViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.technicians.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianCell.identifier,
            for: indexPath
        ) as! TechnicianCell

        let tech = viewModel.technician(at: indexPath.row)

        cell.configure(
            with: tech,
            isCurrentlyAssigned: viewModel.isCurrentlyAssigned(tech)
        )

        // 🔥 closure must be set every time
        cell.onAssignTapped = { [weak self] in
            guard let self else { return }

            self.viewModel.assignTechnician(tech) { success in
                DispatchQueue.main.async {
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showError("Technician could not be assigned. Request not found.")
                    }
                }
            }
        }

        return cell
    }
}
