//
//  AllRequestsViewController.swift
//  Fixify
//

import UIKit

final class AllRequestsViewController: UIViewController {

    private let viewModel = AllRequestsViewModel()
    private var displayedRequests: [Request] = []

    private let tableView = UITableView()
    private let filterButton = UIButton(type: .system)
    private var dropdown: FilterDropdownView?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Requests"
        view.backgroundColor = .systemGroupedBackground

        setupFilterButton()
        setupTableView()

        // 🔥 Listen to Firebase live updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataDidChange),
            name: .technicianRequestsDidChange,
            object: nil
        )

        applyDefaultData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Firebase Updates

    @objc private func dataDidChange() {
        applyDefaultData()
    }

    private func applyDefaultData() {
        displayedRequests = viewModel.allRequests
        tableView.reloadData()
    }

    // MARK: - Filter Button

    private func setupFilterButton() {
        filterButton.setImage(
            UIImage(systemName: "line.3.horizontal.decrease"),
            for: .normal
        )
        filterButton.addTarget(
            self,
            action: #selector(toggleDropdown),
            for: .touchUpInside
        )

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(customView: filterButton)
    }

    @objc private func toggleDropdown() {
        if let dropdown {
            dropdown.removeFromSuperview()
            self.dropdown = nil
            return
        }

        let dropdown = FilterDropdownView()
        dropdown.translatesAutoresizingMaskIntoConstraints = false

        dropdown.onSelectFilter = { [weak self] filter in
            guard let self else { return }
            self.displayedRequests = self.viewModel.filtered(filter)
            self.tableView.reloadData()
            dropdown.removeFromSuperview()
            self.dropdown = nil
        }

        view.addSubview(dropdown)
        self.dropdown = dropdown

        NSLayoutConstraint.activate([
            dropdown.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            dropdown.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            dropdown.widthAnchor.constraint(equalToConstant: 180)
        ])
    }

    // MARK: - TableView

    private func setupTableView() {
        tableView.register(
            RequestCell.self,
            forCellReuseIdentifier: RequestCell.identifier
        )
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}

// MARK: - UITableViewDataSource

extension AllRequestsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        displayedRequests.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestCell.identifier,
            for: indexPath
        ) as! RequestCell

        let request = displayedRequests[indexPath.row]
        cell.configure(with: request)

        cell.onAssignTap = { [weak self] in
            guard let self else { return }

            // 🔒 Business rule
            guard request.status == .pending || request.status == .escalated else {
                return
            }

            let vc = AssignTechnicianViewController(requestID: request.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }
}
