import UIKit

final class TechnicianRequestsViewController: UITableViewController {

    private let store = RequestStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Technician Requests"
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    @objc private func reload() { tableView.reloadData() }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        store.requests.count
    }

    override func tableView(_: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let r = store.requests[index.row]
        cell.textLabel?.text = r.title
        cell.detailTextLabel?.text = r.status.rawValue
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt index: IndexPath) {
        let r = store.requests[index.row]
        store.updateStatus(id: r.id, status: .active)
    }
}

