//
//  AllRequestsViewController.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import UIKit

class AllRequestsViewController: UIViewController, UITableViewDataSource {

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

        viewModel.loadDummyData()
        displayedRequests = viewModel.allRequests
        tableView.reloadData()
    }

    private func setupFilterButton() {
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        filterButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
    }

    @objc private func toggleDropdown() {
        if let d = dropdown {
            d.removeFromSuperview()
            dropdown = nil
            return
        }

        let d = FilterDropdownView(frame: CGRect(x: 16, y: 100, width: 180, height: 170))
        d.onSelectFilter = { [weak self] filter in
            guard let self = self else { return }
            self.displayedRequests = self.viewModel.filtered(filter)
            self.tableView.reloadData()
            d.removeFromSuperview()
            self.dropdown = nil
        }

        dropdown = d
        view.addSubview(d)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedRequests.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: RequestCell.identifier,
            for: indexPath
        ) as! RequestCell

        let request = displayedRequests[indexPath.row]
        cell.configure(with: request)

        cell.onAssignTap = { [weak self] in
            let vc = AssignTechnicianViewController(requestID: request.id)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }

    private func setupTableView() {
        tableView.register(RequestCell.self, forCellReuseIdentifier: RequestCell.identifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}
