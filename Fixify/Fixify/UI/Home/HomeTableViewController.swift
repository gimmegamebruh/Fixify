import UIKit

class HomeTableViewController: UITableViewController {

    private let store = RequestStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Requests"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground

        tableView.register(RequestTableViewCell.self,
                           forCellReuseIdentifier: RequestTableViewCell.reuseID)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @objc private func addTapped() {
        navigationController?.pushViewController(NewRequestViewController(), animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.requests.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestTableViewCell.reuseID,
            for: indexPath
        ) as! RequestTableViewCell

        cell.configure(with: store.requests[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let detail = RequestDetailViewController(requestIndex: indexPath.row)
        navigationController?.pushViewController(detail, animated: true)
    }
}

