import UIKit

final class HomeTableViewController: UITableViewController {

    private let store = RequestStore.shared
    
    private var currentFilter: RequestDateFilter = .all
    private var filteredRequests: [Request] {
        store.requests.filter { currentFilter.includes($0.dateCreated) }
    }


    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No requests yet.\nTap “New Request” to create one."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = DS.Color.subtext
        label.font = DS.Font.body()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Requests"
        tableView.backgroundColor = DS.Color.groupedBg
        tableView.separatorStyle = .none

        tableView.register(
            StudentRequestCardCell.self,
            forCellReuseIdentifier: StudentRequestCardCell.reuseID
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "New Request",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )


        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        tableView.contentInset.bottom = 20

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        updateEmptyState()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions

    @objc private func addTapped() {
        navigationController?.pushViewController(
            NewRequestViewController(),
            animated: true
        )
    }

    @objc private func reload() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
        updateEmptyState()
    }

    @objc private func refreshPulled() {
        reload()
    }

    private func updateEmptyState() {
        tableView.backgroundView = store.requests.isEmpty ? emptyLabel : nil
    }

    // MARK: - Table Data

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        filteredRequests.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentRequestCardCell.reuseID,
            for: indexPath
        ) as! StudentRequestCardCell

        let request = filteredRequests[indexPath.row]
        cell.configure(with: request)

        // EDIT
        cell.onEditTapped = { [weak self] in
            let vc = EditRequestViewController(requestID: request.id)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        // CANCEL
        cell.onCancelTapped = { [weak self] in
            self?.confirmCancel(requestID: request.id)
        }

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let request = store.requests[indexPath.row]
        let vc = RequestDetailViewController(requestID: request.id)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Cancel

    private func confirmCancel(requestID: String) {

        let alert = UIAlertController(
            title: "Cancel Request",
            message: "Are you sure you want to cancel this request?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            RequestStore.shared.updateStatus(
                id: requestID,
                status: .cancelled
            )
        })

        present(alert, animated: true)
    }
    
    @objc private func filterTapped() {
        let sheet = UIAlertController(title: "Filter Requests", message: nil, preferredStyle: .actionSheet)

        RequestDateFilter.allCases.forEach { filter in
            sheet.addAction(UIAlertAction(title: filter.title, style: .default) { _ in
                self.currentFilter = filter
                self.tableView.reloadData()
            })
        }

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

}

