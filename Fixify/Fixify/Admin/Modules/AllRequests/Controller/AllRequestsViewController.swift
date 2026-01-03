import UIKit

final class AllRequestsViewController: UIViewController {

    private let viewModel = AllRequestsViewModel()
    private var displayedRequests: [Request] = []

    private var currentFilter: RequestFilter = .allTime
    private var filterDropdown: FilterDropdownView?

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Requests"
        view.backgroundColor = .systemGroupedBackground

        setupFilterButton()
        setupTableView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        reload()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Filter Button

    private func setupFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(toggleFilterDropdown)
        )
    }

    @objc private func toggleFilterDropdown() {

        // If already visible hide
        if let dropdown = filterDropdown {
            dropdown.removeFromSuperview()
            filterDropdown = nil
            return
        }

        let dropdown = FilterDropdownView()
        dropdown.onSelectFilter = { [weak self] filter in
            self?.currentFilter = filter
            self?.filterDropdown?.removeFromSuperview()
            self?.filterDropdown = nil
            self?.reload()
        }

        view.addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dropdown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dropdown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dropdown.widthAnchor.constraint(equalToConstant: 200)
        ])

        filterDropdown = dropdown
    }

    // MARK: - Reload

    @objc private func reload() {
        displayedRequests = viewModel.filtered(currentFilter) 
        tableView.reloadData()
    }

    // MARK: - Table Setup

    private func setupTableView() {

        tableView.register(
            RequestCell.self,
            forCellReuseIdentifier: RequestCell.identifier
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

    // MARK: - Escalation (NEW LOGIC ONLY)

    private func confirmEscalation(for request: Request) {

        guard request.status != .completed,
              request.status != .cancelled,
              request.status != .escalated
        else { return }

        let alert = UIAlertController(
            title: "Escalate Request",
            message: "This will mark the request as escalated and require admin attention.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Escalate", style: .destructive) { _ in
            RequestStore.shared.updateStatus(
                id: request.id,
                status: .escalated
            )
        })

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AllRequestsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        displayedRequests.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestCell.identifier,
            for: indexPath
        ) as! RequestCell

        let request = displayedRequests[indexPath.row]
        cell.configure(with: request)

        cell.onAssignTap = { [weak self] in
            guard request.status.canAssignTechnician else { return }
            let vc = AssignTechnicianViewController(requestID: request.id)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        cell.onEscalateTap = { [weak self] in
            self?.confirmEscalation(for: request)
        }

        return cell
    }
}
