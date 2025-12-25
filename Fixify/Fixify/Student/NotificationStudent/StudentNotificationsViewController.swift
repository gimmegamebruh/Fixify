//
//  StudentNotificationsViewController.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

final class StudentNotificationsViewController: UITableViewController {

    private let store = RequestStore.shared
    private var notifications: [StudentNotification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"

        tableView.backgroundColor = DS.Color.groupedBg
        tableView.separatorStyle = .none

        tableView.register(
            StudentNotificationCell.self,
            forCellReuseIdentifier: StudentNotificationCell.reuseID
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Build notifications

    @objc private func reload() {
        notifications = buildStudentNotifications()
        tableView.reloadData()
    }

    private func buildStudentNotifications() -> [StudentNotification] {
        guard let studentID = CurrentUser.id else { return [] }

        var result: [StudentNotification] = []

        let myRequests = store.requests.filter { $0.createdBy == studentID }

        for r in myRequests {

            if r.status == .assigned {
                result.append(
                    StudentNotification(
                        id: r.id + "_assigned",
                        requestID: r.id,
                        subtitle: r.title,
                        date: r.dateCreated,
                        type: .assigned
                    )
                )
            }

            if let scheduled = r.scheduledTime {
                result.append(
                    StudentNotification(
                        id: r.id + "_scheduled",
                        requestID: r.id,
                        subtitle: "Visit on \(formatted(date: scheduled))",
                        date: scheduled,
                        type: .scheduled
                    )
                )
            }

            if r.status == .completed {
                result.append(
                    StudentNotification(
                        id: r.id + "_completed",
                        requestID: r.id,
                        subtitle: r.title,
                        date: r.dateCreated,
                        type: .completed
                    )
                )
            }
        }

        return result.sorted { $0.date > $1.date }
    }

    @objc private func clearAll() {
        notifications.removeAll()
        tableView.reloadData()
    }

    // MARK: - Table

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if notifications.isEmpty {
            let label = UILabel()
            label.text = "No notifications yet"
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
            withIdentifier: StudentNotificationCell.reuseID,
            for: indexPath
        ) as! StudentNotificationCell

        cell.configure(with: notifications[indexPath.row])
        return cell
    }

    override func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let n = notifications[indexPath.row]
        let vc = RequestDetailViewController(requestID: n.requestID)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Helpers

    private func formatted(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}
