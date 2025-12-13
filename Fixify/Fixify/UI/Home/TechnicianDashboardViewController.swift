//
//  TechnicianDashboardViewController.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class TechnicianDashboardViewController: UIViewController {

    private let dataStore = TechnicianDataStore.shared
    private var requests: [MaintenanceRequest] = []
    private var selectedFilter: MaintenanceFilter = .all

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UIView()
    private let summaryLabel = UILabel()
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: MaintenanceFilter.allCases.map { $0.title })
        control.selectedSegmentIndex = selectedFilter.rawValue
        control.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        view.backgroundColor = .systemBackground
        configureTableView()
        configureHeader()
        reloadData()
        registerObservers()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(RequestCardCell.self, forCellReuseIdentifier: RequestCardCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureHeader() {
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        segmentedControl.autoresizingMask = [.flexibleWidth]
        summaryLabel.autoresizingMask = [.flexibleWidth]

        let headerHeight: CGFloat = 130
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
        headerView.backgroundColor = .systemBackground
        headerView.subviews.forEach { $0.removeFromSuperview() }

        summaryLabel.frame = CGRect(x: 16, y: 16, width: headerView.bounds.width - 32, height: 28)
        segmentedControl.frame = CGRect(x: 16, y: summaryLabel.frame.maxY + 12, width: headerView.bounds.width - 32, height: 32)

        headerView.addSubview(summaryLabel)
        headerView.addSubview(segmentedControl)
        tableView.tableHeaderView = headerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        let targetSize = CGSize(width: view.bounds.width, height: header.frame.height)
        if header.frame.size != targetSize {
            header.frame.size = targetSize
            tableView.tableHeaderView = header
        }
    }

    private func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDataChange),
                                               name: .technicianRequestsDidChange,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleDataChange() {
        reloadData()
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        guard let filter = MaintenanceFilter(rawValue: sender.selectedSegmentIndex) else { return }
        selectedFilter = filter
        reloadData()
    }

    private func reloadData() {
        requests = dataStore.requests(for: selectedFilter)
        summaryLabel.text = "Assigned Requests · \(dataStore.requests(for: .all).count)"
        tableView.reloadData()
    }
}

extension TechnicianDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestCardCell.reuseIdentifier, for: indexPath) as? RequestCardCell else {
            return UITableViewCell()
        }
        cell.configure(with: requests[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let request = requests[indexPath.row]
        let detailVC = RequestDetailViewController(requestID: request.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
