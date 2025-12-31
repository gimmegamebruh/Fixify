//
//  StartChatViewController.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//

import UIKit

final class StartChatViewController: UITableViewController {

    private let store = RequestStore.shared
    private var availableRequests: [Request] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Start Chat"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdate),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    @objc private func handleUpdate() {
        reloadData()
    }

    private func reloadData() {
        availableRequests = store.requests.filter {
            $0.createdBy == CurrentUser.id &&
            ($0.status == .assigned || $0.status == .active) &&
            $0.assignedTechnicianID != nil
        }

        tableView.reloadData()
    }

    // MARK: - Table

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        if availableRequests.isEmpty {
            tableView.backgroundView = emptyState()
        } else {
            tableView.backgroundView = nil
        }

        return availableRequests.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let request = availableRequests[indexPath.row]

        cell.textLabel?.text = request.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        let request = availableRequests[indexPath.row]
        let chat = ChatViewController(requestID: request.id)

        navigationController?.pushViewController(chat, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func emptyState() -> UIView {
        let label = UILabel()
        label.text = "No assigned requests yet.\nA technician must be assigned first."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
