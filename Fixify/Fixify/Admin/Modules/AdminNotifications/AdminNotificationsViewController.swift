//
//  AdminNotificationsViewController.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class AdminNotificationsViewController: UITableViewController {

    private let store = RequestStore.shared
    private var notifications: [AdminNotification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"

        tableView.backgroundColor = DS.Color.groupedBg
        tableView.separatorStyle = .none

        tableView.register(
            AdminNotificationCell.self,
            forCellReuseIdentifier: AdminNotificationCell.reuseID
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Mark All as Read",
            style: .plain,
            target: self,
            action: #selector(markAllRead)
        )

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

    // MARK: - Data

    @objc private func reload() {
        notifications = buildAdminNotifications()
        tableView.reloadData()
    }

    private func buildAdminNotifications() -> [AdminNotification] {

        var result: [AdminNotification] = []

        for request in store.requests {

            // 1️⃣ New request created
            if request.status == .pending {
                result.append(
                    AdminNotification(
                        id: request.id + "_new",
                        subtitle: request.title,
                        date: request.dateCreated,
                        type: .newRequest
                    )
                )
            }

            // 2️⃣ Escalated request
            if request.status == .escalated {
                result.append(
                    AdminNotification(
                        id: request.id + "_esc",
                        subtitle: request.title,
                        date: request.dateCreated,
                        type: .escalated
                    )
                )
            }

            // 3️⃣ Completed request
            if request.status == .completed {
                result.append(
                    AdminNotification(
                        id: request.id + "_done",
                        subtitle: request.title,
                        date: request.dateCreated,
                        type: .completed
                    )
                )
            }
        }

        return result.sorted { $0.date > $1.date }
    }

    @objc private func markAllRead() {
        // UI-only reset (acceptable for coursework)
        notifications.removeAll()
        tableView.reloadData()
    }

    // MARK: - Table

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if notifications.isEmpty {
            let label = UILabel()
            label.text = "No notifications"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        return notifications.count
    }

    override func tableView(
        _: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminNotificationCell.reuseID,
            for: indexPath
        ) as! AdminNotificationCell

        cell.configure(with: notifications[indexPath.row])
        return cell
    }

    override func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let notification = notifications[indexPath.row]

        if let request = store.requests.first(where: { $0.id == notification.id.prefix(while: { $0 != "_" }) }) {
            let vc = AssignTechnicianViewController(requestID: request.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
