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

        availableRequests = store.requests.filter {
            $0.createdBy == CurrentUser.id &&
            $0.status == .active &&
            $0.assignedTechnicianID != nil
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        availableRequests.count
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
    }
}
