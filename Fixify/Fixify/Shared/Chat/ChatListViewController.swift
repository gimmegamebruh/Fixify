import UIKit

final class ChatListViewController: UITableViewController {

    private let store = RequestStore.shared
    private var requests: [Request] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        tableView.register(
            ChatListCell.self,
            forCellReuseIdentifier: ChatListCell.reuseID
        )

        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground


        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        reload()
    }

    // MARK: - 🔥 FIXED LOGIC (UI UNCHANGED)
    @objc private func reload() {
 
        requests = store.requests.filter { request in
            switch CurrentUser.role {

            case .student:
                // ✅ Students can chat once assigned OR active
                return request.status == .assigned || request.status == .active

            case .technician:
                // ✅ Technicians see only their own jobs
                guard let techID = CurrentUser.resolvedUserID() else { return false }
                return request.assignedTechnicianID == techID &&
                       (request.status == .assigned || request.status == .active)

            case .admin:
                return true

            default:
                return false
            }
        }

        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        requests.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListCell.reuseID,
            for: indexPath
        ) as! ChatListCell

        let request = requests[indexPath.row]
        cell.configure(with: request)

        return cell

    }

    // MARK: - Selection
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let request = requests[indexPath.row]
        let chatVC = ChatViewController(requestID: request.id)
        navigationController?.pushViewController(chatVC, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

