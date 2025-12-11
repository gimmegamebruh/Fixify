import UIKit

class AllRequestsViewController: UIViewController,
                                 UITableViewDataSource,
                                 UITableViewDelegate {

    private let tableView = UITableView()
    private let viewModel = AllRequestsViewModel()
    private var displayed: [Request] = []

    private var dropdown: FilterDropdownView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Requests Overview"
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)

        setupFilterButton()
        setupTableView()

        viewModel.loadDummyData()
        displayed = viewModel.allRequests
        tableView.reloadData()
    }

    // MARK: - Filter Button
    private func setupFilterButton() {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }

    @objc private func toggleDropdown() {
        if let dd = dropdown {
            dd.removeFromSuperview()
            dropdown = nil
            return
        }

        let dd = FilterDropdownView(frame: CGRect(x: 16, y: 90, width: 180, height: 170))
        dd.onSelectFilter = { [weak self] filter in
            guard let self = self else { return }
            self.displayed = self.viewModel.filtered(filter)
            self.tableView.reloadData()
            dd.removeFromSuperview()
            self.dropdown = nil
        }

        dropdown = dd
        view.addSubview(dd)
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayed.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestCell.identifier,
            for: indexPath) as! RequestCell

        cell.configure(with: displayed[indexPath.row])
        return cell
    }
}
