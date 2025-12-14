import UIKit

class NotificationsViewController: UITableViewController {

    private var items: [NotificationItem] = [
        .init(icon: "checkmark.circle.fill", title: "Request submitted successfully",
              subtitle: "Your request was submitted • 2 min ago", tint: .systemGreen),
        .init(icon: "play.circle.fill", title: "Request in progress",
              subtitle: "Technician started working • 1 hour ago", tint: .systemBlue),
        .init(icon: "checkmark.circle.fill", title: "Request completed",
              subtitle: "Your request has been completed • 4 hours ago", tint: .systemGreen)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseID)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.reuseID,
            for: indexPath
        ) as! NotificationCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

