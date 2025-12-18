//
//  EscalatedRequestsViewController.swift
//  Fixify
//

import UIKit

final class EscalatedRequestsViewController: UIViewController {

    private let viewModel = EscalatedRequestsViewModel()
    private var displayed: [Request] = []

    private let tableView = UITableView()
    private let segmentedControl = UISegmentedControl(
        items: EscalationFilter.allCases.map { $0.rawValue }
    )

    private var currentFilter: EscalationFilter = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Escalated Requests"
        view.backgroundColor = .systemGroupedBackground

        setupSegment()
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Always reload from source of truth
        viewModel.loadData()
        displayed = viewModel.filtered(by: currentFilter)
        tableView.reloadData()
    }

    private func setupSegment() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(filterChanged),
                                   for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }

    @objc private func filterChanged() {
        currentFilter = EscalationFilter.allCases[segmentedControl.selectedSegmentIndex]
        displayed = viewModel.filtered(by: currentFilter)
        tableView.reloadData()
    }

    private func setupTable() {
        tableView.register(
            EscalatedRequestCell.self,
            forCellReuseIdentifier: EscalatedRequestCell.identifier
        )
        tableView.dataSource = self
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension EscalatedRequestsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        displayed.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: EscalatedRequestCell.identifier,
            for: indexPath
        ) as! EscalatedRequestCell

        let request = displayed[indexPath.row]

        // ✅ This now works because ViewModel has type(for:)
        cell.configure(
            with: request,
            escalationType: currentFilter == .all
                ? viewModel.type(for: request)
                : currentFilter
        )

        cell.onViewTap = { [weak self] in
            let vc = EscalationDetailViewController(request: request)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }
}
