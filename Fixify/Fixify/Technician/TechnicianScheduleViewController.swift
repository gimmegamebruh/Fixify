import UIKit

final class TechnicianScheduleViewController: UITableViewController {

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

    private enum ScheduleSort: Int, CaseIterable {
        case newest
        case oldest

        var title: String {
            switch self {
            case .newest: return "Schedule: Newest"
            case .oldest: return "Schedule: Oldest"
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

    private let store = RequestStore.shared
    private let infoLabel = UILabel()
    private let scheduleSortControl = UISegmentedControl()
    private let dateFilterControl = UISegmentedControl()
    private let priorityControl = UISegmentedControl()
    private let assignmentControl = UISegmentedControl()
    private let statusControl = UISegmentedControl()

    private var scheduleSort: ScheduleSort = .newest
    private var dateFilter: RequestDateFilter = .all
    private var priorityFilter: PriorityFilter = .all
    private var assignmentSourceFilter: AssignmentSourceFilter = .all
    private var statusFilter: StatusFilter = .all

    private var scheduled: [Request] {
        store.requests.filter { request in
            guard CurrentUser.role == .technician, let techID = CurrentUser.userID else { return false }
            return request.assignedTechnicianID == techID
        }
    }

    private var filteredScheduled: [Request] {
        scheduled
            .filter { matchesDate($0) }
            .filter { matchesPriority($0) }
            .filter { matchesAssignmentSource($0) }
            .filter { matchesStatus($0) }
            .sorted { lhs, rhs in
                let leftDate = selectedDate(for: lhs)
                let rightDate = selectedDate(for: rhs)
                switch scheduleSort {
                case .newest:
                    return leftDate > rightDate
                case .oldest:
                    return leftDate < rightDate
                }
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        tableView.register(TechnicianScheduleCell.self, forCellReuseIdentifier: TechnicianScheduleCell.reuseID)
        tableView.separatorStyle = .none
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = refresher
        configureHeader()
        updateEmptyState()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "History",
            style: .plain,
            target: self,
            action: #selector(openHistory)
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    private func configureHeader() {
        infoLabel.font = .boldSystemFont(ofSize: 17)
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .label

        scheduleSortControl.removeAllSegments()
        ScheduleSort.allCases.enumerated().forEach { idx, sort in
            scheduleSortControl.insertSegment(withTitle: sort.title, at: idx, animated: false)
        }
        scheduleSortControl.selectedSegmentIndex = scheduleSort.rawValue
        scheduleSortControl.addTarget(self, action: #selector(scheduleSortChanged), for: .valueChanged)

        statusControl.removeAllSegments()
        StatusFilter.allCases.enumerated().forEach { idx, filter in
            statusControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        statusControl.selectedSegmentIndex = statusFilter.rawValue
        statusControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)

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

        assignmentControl.removeAllSegments()
        AssignmentSourceFilter.allCases.enumerated().forEach { idx, filter in
            assignmentControl.insertSegment(withTitle: filter.title, at: idx, animated: false)
        }
        assignmentControl.selectedSegmentIndex = assignmentSourceFilter.rawValue
        assignmentControl.addTarget(self, action: #selector(assignmentChanged), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [
            infoLabel,
            scheduleSortControl,
            statusControl,
            dateFilterControl,
            priorityControl,
            assignmentControl
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        let header = UIView()
        header.backgroundColor = .secondarySystemBackground
        header.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
        ])

        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 230)
        tableView.tableHeaderView = header
        updateHeader()
    }

    private func updateHeader() {
        let assignedCount = scheduled.count
        let count = filteredScheduled.count
        infoLabel.text = "Assigned to you: \(assignedCount) • Showing: \(count) • Sort: \(scheduleSort.title.lowercased()) • Priority: \(priorityFilter.title)"
    }

    @objc private func reload() {
        updateHeader()
        updateEmptyState()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    @objc private func scheduleSortChanged() {
        scheduleSort = ScheduleSort(rawValue: scheduleSortControl.selectedSegmentIndex) ?? .newest
        reload()
    }

    @objc private func statusChanged() {
        statusFilter = StatusFilter(rawValue: statusControl.selectedSegmentIndex) ?? .all
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

    @objc private func assignmentChanged() {
        assignmentSourceFilter = AssignmentSourceFilter(rawValue: assignmentControl.selectedSegmentIndex) ?? .all
        reload()
    }

    private func updateEmptyState() {
        if scheduled.isEmpty {
            let label = UILabel()
            label.text = "You don't have any assigned requests to schedule."
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            tableView.backgroundView = label
        } else if filteredScheduled.isEmpty {
            let label = UILabel()
            label.text = "No scheduled requests match your filters."
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
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

    private func matchesStatus(_ request: Request) -> Bool {
        switch statusFilter {
        case .all:
            return request.status != .cancelled && request.status != .completed
        case .active:
            return request.status == .active
        case .pending:
            return request.status == .pending || request.status == .assigned
        case .cancelled:
            return request.status == .cancelled
        case .completed:
            return request.status == .completed
        }
    }

    private func selectedDate(for request: Request) -> Date {
        return request.scheduledTime ?? request.dateCreated
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredScheduled.count
    }

    override func tableView(_: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianScheduleCell.reuseID,
            for: index
        ) as? TechnicianScheduleCell else { return UITableViewCell() }
        cell.configure(with: filteredScheduled[index.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = filteredScheduled[indexPath.row]
        let detail = TechnicianRequestDetailViewController(request: request)
        navigationController?.pushViewController(detail, animated: true)
    }

    @objc private func openHistory() {
        navigationController?.pushViewController(TechnicianHistoryViewController(), animated: true)
    }
}

private final class TechnicianScheduleCell: UITableViewCell {
    static let reuseID = "TechnicianScheduleCell"

    private let titleLabel = UILabel()
    private let metaLabel = UILabel()
    private let badge = PaddingLabel()
    private let container = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with request: Request) {
        titleLabel.text = request.title

        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        let time: String
        let scheduleStatus: String
        if let scheduled = request.scheduledTime {
            time = df.string(from: scheduled)
            scheduleStatus = "Scheduled"
        } else {
            time = df.string(from: request.dateCreated)
            scheduleStatus = "Not scheduled yet"
        }
        metaLabel.text = "\(request.location) • \(request.category) • \(scheduleStatus): \(time)"

        badge.text = request.priority.rawValue.capitalized
        badge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        badge.textColor = .systemOrange

        container.layer.borderColor = request.priority.color.withAlphaComponent(0.7).cgColor
    }

    private func setupUI() {
        container.layer.cornerRadius = 12
        container.backgroundColor = .systemBackground
        container.layer.borderColor = UIColor.separator.cgColor
        container.layer.borderWidth = 1.5
        container.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 17)
        metaLabel.font = .systemFont(ofSize: 14)
        metaLabel.textColor = .secondaryLabel

        badge.font = .systemFont(ofSize: 12, weight: .semibold)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 6
        badge.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, metaLabel, badge])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(container)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
}
