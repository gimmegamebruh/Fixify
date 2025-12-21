import UIKit

final class TechnicianScheduleViewController: UITableViewController {

    private let store = RequestStore.shared
    private var scheduled: [Request] {
        store.requests
            .filter { request in
                guard request.scheduledTime != nil else { return false }
                if let techID = CurrentUser.technicianID ?? CurrentUser.id {
                    return request.assignedTo == techID
                }
                return true
            }
            .sorted { (lhs, rhs) in
                let leftDate = lhs.scheduledTime ?? lhs.dateCreated
                let rightDate = rhs.scheduledTime ?? rhs.dateCreated
                return leftDate < rightDate
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        tableView.register(TechnicianScheduleCell.self, forCellReuseIdentifier: TechnicianScheduleCell.reuseID)
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    @objc private func reload() { tableView.reloadData() }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        scheduled.count
    }

    override func tableView(_: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianScheduleCell.reuseID,
            for: index
        ) as? TechnicianScheduleCell else { return UITableViewCell() }
        cell.configure(with: scheduled[index.row])
        return cell
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
        let time = df.string(from: request.scheduledTime ?? request.dateCreated)
        metaLabel.text = "\(request.location) • \(request.category) • \(time)"

        badge.text = request.priority.rawValue.capitalized
        badge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        badge.textColor = .systemOrange
    }

    private func setupUI() {
        container.layer.cornerRadius = 12
        container.backgroundColor = .systemBackground
        container.layer.borderColor = UIColor.separator.cgColor
        container.layer.borderWidth = 1
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
