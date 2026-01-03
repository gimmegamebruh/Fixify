import UIKit

// This controller shows all maintenance requests created by the student
// It displays the requests in a table view with options to edit or cancel
final class HomeTableViewController: UITableViewController {

    // Shared store that contains all requests
    private let store = RequestStore.shared
    
    // Currently selected filter (all, today, this week, etc.)
    private var currentFilter: RequestDateFilter = .all

    // Requests after applying the selected date filter
    private var filteredRequests: [Request] {
        store.requests.filter { currentFilter.includes($0.dateCreated) }
    }

    // Label shown when there are no requests
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No requests yet.\nTap “New Request” to create one."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = DS.Color.subtext
        label.font = DS.Font.body()
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Screen title
        title = "My Requests"

        // Table view styling
        tableView.backgroundColor = DS.Color.groupedBg
        tableView.separatorStyle = .none

        // Register custom cell used to display request cards
        tableView.register(
            StudentRequestCardCell.self,
            forCellReuseIdentifier: StudentRequestCardCell.reuseID
        )

        // Button to create a new request
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "New Request",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        
        // Button to filter requests by date
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )

        // Enable dynamic cell height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        tableView.contentInset.bottom = 20

        // Pull to refresh setup
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)

        // Listen for updates from technician or backend
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        // Show empty message if needed
        updateEmptyState()
    }

    // Remove observer when screen is destroyed
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions

    // Opens screen to create a new request
    @objc private func addTapped() {
        navigationController?.pushViewController(
            NewRequestViewController(),
            animated: true
        )
    }

    // Reloads table view data
    @objc private func reload() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
        updateEmptyState()
    }

    // Called when user pulls to refresh
    @objc private func refreshPulled() {
        reload()
    }

    // Shows or hides empty label based on data
    private func updateEmptyState() {
        tableView.backgroundView = store.requests.isEmpty ? emptyLabel : nil
    }

    // MARK: - Table View Data Source

    // Number of rows based on filtered requests
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        filteredRequests.count
    }

    // Creates and configures each table cell
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

        // When edit button is tapped
        cell.onEditTapped = { [weak self] in
            let vc = EditRequestViewController(requestID: request.id)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        // When cancel button is tapped
        cell.onCancelTapped = { [weak self] in
            self?.confirmCancel(requestID: request.id)
        }

        return cell
    }

    // Opens request details when cell is tapped
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let request = store.requests[indexPath.row]
        let vc = RequestDetailViewController(requestID: request.id)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Cancel Request

    // Shows confirmation alert before cancelling request
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
    
    // MARK: - Filter

    // Shows filter options using an action sheet
    @objc private func filterTapped() {

        let sheet = UIAlertController(
            title: "Filter Requests",
            message: nil,
            preferredStyle: .actionSheet
        )

        // Add filter options dynamically
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
