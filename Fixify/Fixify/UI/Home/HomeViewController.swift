import UIKit

class HomeViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let store = RequestStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "My Requests"

        setupNavBar()
        setupTableView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160

        tableView.register(RequestTableViewCell.self,
                           forCellReuseIdentifier: RequestTableViewCell.reuseID)

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func addTapped() {
        let newVC = NewRequestViewController()
        navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return store.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestTableViewCell.reuseID,
            for: indexPath
        ) as? RequestTableViewCell else {
            return UITableViewCell()
        }

        let request = store.request(at: indexPath.row)
        cell.configure(with: request)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let detailVC = RequestDetailViewController(requestIndex: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

