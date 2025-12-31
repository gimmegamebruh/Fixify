import UIKit

final class ChatListViewController: UITableViewController {

    private let store = RequestStore.shared
    private var chats: [Request] = []

    private lazy var newChatButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Start New Chat", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.addTarget(self, action: #selector(startNewChat), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"

        tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem =
            CurrentUser.role == .student
            ? UIBarButtonItem(customView: newChatButton)
            : nil

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )

        reload()
    }

    @objc private func reload() {

        print("========== CHAT RELOAD ==========")
        print("👤 CurrentUser.role =", CurrentUser.role)
        print("👤 CurrentUser.id   =", CurrentUser.id)
        print("👤 technicianID     =", CurrentUser.technicianID ?? "nil")
        print("📦 Total requests in store =", store.requests.count)

        for r in store.requests {
            print("""
            🔹 Request:
            id = \(r.id)
            createdBy = \(r.createdBy)
            status = \(r.status.rawValue)
            assignedTechnicianID = \(r.assignedTechnicianID ?? "nil")
            """)
        }

        switch CurrentUser.role {

        case .student:
            chats = store.requests.filter { request in

                print("🧪 Checking request \(request.id)")

                guard request.createdBy == CurrentUser.id else {
                    print("❌ rejected: createdBy mismatch")
                    return false
                }

                guard request.assignedTechnicianID != nil else {
                    print("❌ rejected: no technician assigned")
                    return false
                }

                switch request.status {
                case .assigned, .active, .completed:
                    print("✅ accepted")
                    return true
                default:
                    print("❌ rejected: invalid status")
                    return false
                }
            }

        case .technician:
            let techID = CurrentUser.technicianID ?? CurrentUser.id

            chats = store.requests.filter { request in
                let match = request.assignedTechnicianID == techID
                print("🧪 Tech check \(request.id) → \(match)")
                return match
            }

        case .admin:
            chats = []
        }

        print("✅ Chats count after filter =", chats.count)
        print("================================")

        tableView.reloadData()
    }



    // MARK: - Table

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chats.isEmpty {
            tableView.backgroundView = emptyState()
        } else {
            tableView.backgroundView = nil
        }
        return chats.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListCell.reuseID,
            for: indexPath
        ) as! ChatListCell

        cell.configure(with: chats[indexPath.row])
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let request = chats[indexPath.row]
        let vc = ChatViewController(requestID: request.id)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - New Chat

    @objc private func startNewChat() {
        let vc = StartChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func emptyState() -> UIView {
        let label = UILabel()
        label.text = "No chats yet\nStart a chat from your requests"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
