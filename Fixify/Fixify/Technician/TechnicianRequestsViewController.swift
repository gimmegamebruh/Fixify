import UIKit

final class TechnicianRequestsViewController: UITableViewController {

    private enum CreatedSort: Int, CaseIterable {
        case newest
        case oldest

        var title: String {
            switch self {
            case .newest: return "Created: Newest"
            case .oldest: return "Created: Oldest"
            }
        }
    }

    private enum PriorityFilter: Int, CaseIterable {
        case all, low, medium, high, urgent

        var title: String {
            switch self {
            case .all: return "All"
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .urgent: return "Urgent"
            }
        }
    }

    private enum AssignmentSourceFilter: Int, CaseIterable {
        case all, admin, selfAssigned

        var title: String {
            switch self {
            case .all: return "All"
            case .admin: return "Admin"
            case .selfAssigned: return "Self"
            }
        }
    }

    private enum StatusFilter: Int, CaseIterable {
        case all, active, pending, cancelled, completed

        var title: String {
            switch self {
            case .all: return "All"
            case .active: return "Active"
            case .pending: return "Pending"
            case .cancelled: return "Cancelled"
            case .completed: return "Completed"
            }
        }
    }

    private enum AssignmentFilter: Int, CaseIterable {
        case all, assignedToMe, unassigned

        var title: String {
            switch self {
            case .all: return "All"
            case .assignedToMe: return "Assigned"
            case .unassigned: return "Not Assigned"
            }
        }
    }

    private let store = RequestStore.shared
    private let countLabel = UILabel()
    private let statusControl = UISegmentedControl()
    private let assignmentControl = UISegmentedControl()
    private let createdSortControl = UISegmentedControl()
    private let dateFilterControl = UISegmentedControl()
    private let priorityControl = UISegmentedControl()
    private let assignmentSourceControl = UISegmentedControl()
    private var statusFilter: StatusFilter = .all
    private var assignmentFilter: AssignmentFilter = .all
    private var createdSort: CreatedSort = .newest
    private var dateFilter: RequestDateFilter = .all
    private var priorityFilter: PriorityFilter = .all
    private var assignmentSourceFilter: AssignmentSourceFilter = .all

    private var technicianUserID: String? {
        guard CurrentUser.role == .technician else { return nil }
        return CurrentUser.userID
    }

    private var filteredRequests: [Request] {
        store.requests.filter { request in
            guard matchesAssignmentFilter(request) else { return false }
            guard matchesDate(request) else { return false }
            guard matchesPriority(request) else { return false }
            guard matchesAssignmentSource(request) else { return false }

        switch statusFilter {
        case .all: return request.status != .cancelled && request.status != .completed
        case .active: return request.status == .active
        case .pending: return request.status == .pending || request.status == .assigned
        case .cancelled: return request.status == .cancelled
        case .completed: return request.status == .completed
        }
        }
        .sorted { lhs, rhs in
            switch createdSort {
            case .newest:
                return lhs.dateCreated > rhs.dateCreated
            case .oldest:
                return lhs.dateCreated < rhs.dateCreated
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Requests"
        tableView.register(TechnicianRequestCell.self, forCellReuseIdentifier: TechnicianRequestCell.reuseID)
        tableView.separatorStyle = .none
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = refresher
        configureHeader()
        updateEmptyState()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Schedule",
            style: .plain,
            target: self,
            action: #selector(openSchedule)
        )

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

        statusControl.removeAllSegments()
        StatusFilter.allCases.enumerated().forEach { idx, filter in
            statusControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        statusControl.selectedSegmentIndex = statusFilter.rawValue
        statusControl.addTarget(self, action: #selector(statusFilterChanged), for: .valueChanged)

        assignmentControl.removeAllSegments()
        AssignmentFilter.allCases.enumerated().forEach { idx, filter in
            assignmentControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        assignmentControl.selectedSegmentIndex = assignmentFilter.rawValue
        assignmentControl.addTarget(self, action: #selector(assignmentFilterChanged), for: .valueChanged)

        createdSortControl.removeAllSegments()
        CreatedSort.allCases.enumerated().forEach { idx, sort in
            createdSortControl.insertSegment(withTitle: sort.title, at: idx, animated: false)
        }
        createdSortControl.selectedSegmentIndex = createdSort.rawValue
        createdSortControl.addTarget(self, action: #selector(createdSortChanged), for: .valueChanged)

        dateFilterControl.removeAllSegments()
        RequestDateFilter.allCases.enumerated().forEach { idx, filter in
            dateFilterControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        dateFilterControl.selectedSegmentIndex = RequestDateFilter.allCases.firstIndex(of: dateFilter) ?? 0
        dateFilterControl.addTarget(self, action: #selector(dateFilterChanged), for: .valueChanged)

        priorityControl.removeAllSegments()
        PriorityFilter.allCases.enumerated().forEach { idx, filter in
            priorityControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        priorityControl.selectedSegmentIndex = priorityFilter.rawValue
        priorityControl.addTarget(self, action: #selector(priorityChanged), for: .valueChanged)

        assignmentSourceControl.removeAllSegments()
        AssignmentSourceFilter.allCases.enumerated().forEach { idx, filter in
            assignmentSourceControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        assignmentSourceControl.selectedSegmentIndex = assignmentSourceFilter.rawValue
        assignmentSourceControl.addTarget(self, action: #selector(assignmentSourceChanged), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [
            countLabel,
            statusControl,
            assignmentControl,
            createdSortControl,
            dateFilterControl,
            priorityControl,
            assignmentSourceControl
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
        ])

        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 220)
        tableView.tableHeaderView = header
        updateHeader()
    }

    private func updateHeader() {
        let assignedToMe = store.requests.filter { request in
            guard let technicianUserID else { return false }
            return request.assignedTechnicianID == technicianUserID
        }.count
        let unassigned = store.requests.filter { !$0.isAssigned }.count
        countLabel.text = "Requests: \(store.requests.count) • Assigned to you: \(assignedToMe) • Not assigned: \(unassigned)"
    }

    @objc private func statusFilterChanged() {
        statusFilter = StatusFilter(rawValue: statusControl.selectedSegmentIndex) ?? .all
        reload()
    }

    @objc private func assignmentFilterChanged() {
        assignmentFilter = AssignmentFilter(rawValue: assignmentControl.selectedSegmentIndex) ?? .all
        reload()
    }

    @objc private func createdSortChanged() {
        createdSort = CreatedSort(rawValue: createdSortControl.selectedSegmentIndex) ?? .newest
        reload()
    }

    @objc private func dateFilterChanged() {
        let allCases = Array(RequestDateFilter.allCases)
        let index = dateFilterControl.selectedSegmentIndex
        dateFilter = allCases.indices.contains(index) ? allCases[index] : .all
        reload()
    }

    @objc private func priorityChanged() {
        priorityFilter = PriorityFilter(rawValue: priorityControl.selectedSegmentIndex) ?? .all
        reload()
    }

    @objc private func assignmentSourceChanged() {
        assignmentSourceFilter = AssignmentSourceFilter(rawValue: assignmentSourceControl.selectedSegmentIndex) ?? .all
        reload()
    }

    @objc private func openSchedule() {
        navigationController?.pushViewController(TechnicianScheduleViewController(), animated: true)
    }

    @objc private func reload() {
        updateHeader()
        updateEmptyState()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    private func updateEmptyState() {
        guard filteredRequests.isEmpty else {
            tableView.backgroundView = nil
            return
        }
        let label = UILabel()
        label.text = "No requests match your filters."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        tableView.backgroundView = label
    }

    private func matchesAssignmentFilter(_ request: Request) -> Bool {
        switch assignmentFilter {
        case .all:
            return true
        case .assignedToMe:
            guard let technicianUserID else { return false }
            return request.assignedTechnicianID == technicianUserID && request.isAssigned
        case .unassigned:
            return !request.isAssigned
        }
    }

    private func matchesDate(_ request: Request) -> Bool {
        let date = selectedDate(for: request)
        return dateFilter.includes(date)
    }

    private func matchesPriority(_ request: Request) -> Bool {
        switch priorityFilter {
        case .all: return true
        case .low: return request.priority == .low
        case .medium: return request.priority == .medium
        case .high: return request.priority == .high
        case .urgent: return request.priority == .urgent
        }
    }

    private func matchesAssignmentSource(_ request: Request) -> Bool {
        let source = request.effectiveAssignmentSource

        switch assignmentSourceFilter {
        case .all:
            return true
        case .admin:
            return source == .admin
        case .selfAssigned:
            return source == .technician
        }
    }

    private func selectedDate(for request: Request) -> Date {
        return request.dateCreated
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
