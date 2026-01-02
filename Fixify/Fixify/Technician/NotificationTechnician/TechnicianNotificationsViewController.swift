//
//  TechnicianNotificationsViewController.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class TechnicianNotificationsViewController: UITableViewController {

    private let store = RequestStore.shared
    private var notifications: [TechnicianNotification] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none

        tableView.register(
            TechnicianNotificationCell.self,
            forCellReuseIdentifier: TechnicianNotificationCell.reuseID
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Mark All as Read",
            style: .plain,
            target: self,
            action: #selector(clearAll)
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        reload()
    }

    @objc private func clearAll() {
        notifications.removeAll()
        tableView.reloadData()
    }

    @objc private func reload() {
        notifications = TechnicianNotificationBuilder.build(
            from: store.requests,
            technicianID: CurrentUser.technicianID ?? CurrentUser.id
        )
        tableView.reloadData()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {

        if notifications.isEmpty {
            tableView.backgroundView = emptyState()
        } else {
            tableView.backgroundView = nil
        }

        return notifications.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TechnicianNotificationCell.reuseID,
            for: indexPath
        ) as! TechnicianNotificationCell

        cell.configure(with: notifications[indexPath.row])
        return cell
    }

    private func emptyState() -> UIView {
        let label = UILabel()
        label.text = "No notifications yet"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
