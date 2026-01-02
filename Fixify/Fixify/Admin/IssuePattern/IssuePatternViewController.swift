import UIKit

final class IssuePatternViewController: UITableViewController {

    private let viewModel = IssuePatternViewModel()
    private var data: [(key: String, count: Int)] = []

    private let segmentedControl = UISegmentedControl(items: [
        "By Location",
        "By Category"
    ])

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Issue Patterns"
        view.backgroundColor = .systemGroupedBackground

        tableView.register(
            IssuePatternCell.self,
            forCellReuseIdentifier: IssuePatternCell.identifier
        )

        tableView.separatorStyle = .none
        tableView.contentInset.top = 12
        tableView.contentInset.bottom = 24

        setupSegmentedControl()
        reloadData()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadData),
            name: .technicianRequestsDidChange,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Segmented Control

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )
        navigationItem.titleView = segmentedControl
    }

    @objc private func segmentChanged() {
        reloadData()
    }

    // MARK: - Data

    @objc private func reloadData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            data = viewModel.issuesByLocation()
        } else {
            data = viewModel.issuesByCategory()
        }
        tableView.reloadData()
    }

    // MARK: - TableView

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        data.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IssuePatternCell.identifier,
            for: indexPath
        ) as! IssuePatternCell

        let item = data[indexPath.row]
        cell.configure(
            title: item.key,
            count: item.count,
            rank: indexPath.row + 1
        )

        return cell
    }
}
