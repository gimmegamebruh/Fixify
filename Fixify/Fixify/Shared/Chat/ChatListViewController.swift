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
        switch CurrentUser.role {
        case .student:
            chats = store.requests.filter {
                $0.createdBy == CurrentUser.id &&
                ($0.status == .active || $0.status == .completed)
            }

        case .technician:
            let techID = CurrentUser.technicianID ?? CurrentUser.id
            chats = store.requests.filter {
                $0.assignedTechnicianID == techID
            }

        case .admin:
            chats = []
        }

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
