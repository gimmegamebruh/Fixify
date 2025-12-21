import UIKit

final class TechnicianRequestsViewController: UITableViewController {

    private enum Filter: Int, CaseIterable {
        case all, active, completed, pending

        var title: String {
            switch self {
            case .all: return "All"
            case .active: return "Active"
            case .completed: return "Completed"
            case .pending: return "Pending"
            }
        }
    }

    private let store = RequestStore.shared
    private let countLabel = UILabel()
    private let filterControl = UISegmentedControl()
    private var filter: Filter = .all

    private var assignedRequests: [Request] {
        let techID = CurrentUser.technicianID ?? CurrentUser.id
        return store.requests.filter { request in
            guard let techID else {
                return true // fallback during setup so lists still render
            }
            return request.assignedTechnicianID == techID
        }
    }

    private var filteredRequests: [Request] {
        assignedRequests.filter { request in
            switch filter {
            case .all: return true
            case .active: return request.status == .active
            case .completed: return request.status == .completed
            case .pending: return request.status == .pending
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Assigned Requests"
        tableView.register(TechnicianRequestCell.self, forCellReuseIdentifier: TechnicianRequestCell.reuseID)
        tableView.separatorStyle = .none
        configureHeader()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    private func configureHeader() {
        let header = UIView()
        header.backgroundColor = .secondarySystemBackground

        countLabel.font = .boldSystemFont(ofSize: 18)
        countLabel.textColor = .label
        countLabel.numberOfLines = 0

        filterControl.removeAllSegments()
        Filter.allCases.enumerated().forEach { idx, filter in
            filterControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        filterControl.selectedSegmentIndex = filter.rawValue
        filterControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [countLabel, filterControl])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
        ])

        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 96)
        tableView.tableHeaderView = header
        updateHeader()
    }

    private func updateHeader() {
        let total = assignedRequests.count
        let activeCount = assignedRequests.filter { $0.status == .active }.count
        countLabel.text = "Assigned: \(total) • Active now: \(activeCount)"
    }

    @objc private func filterChanged() {
        filter = Filter(rawValue: filterControl.selectedSegmentIndex) ?? .all
        reload()
    }

    @objc private func reload() {
        updateHeader()
        tableView.reloadData()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredRequests.count
    }

    override func tableView(_: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianRequestCell.reuseID,
            for: index
        ) as? TechnicianRequestCell else { return UITableViewCell() }

        cell.configure(with: filteredRequests[index.row])
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt index: IndexPath) {
        let r = filteredRequests[index.row]
        let detail = TechnicianRequestDetailViewController(request: r)
        navigationController?.pushViewController(detail, animated: true)
    }
}
