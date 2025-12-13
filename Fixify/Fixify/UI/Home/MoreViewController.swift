//
//  MoreViewController.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class MoreViewController: UITableViewController {

    private enum Option: Int, CaseIterable {
        case completedHistory

        var title: String {
            switch self {
            case .completedHistory:
                return "Completed"
            }
        }

        var subtitle: String {
            switch self {
            case .completedHistory:
                return "View finished requests"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.backgroundColor = .systemGroupedBackground
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Option.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
        guard let option = Option(rawValue: indexPath.row) else { return cell }
        var content = cell.defaultContentConfiguration()
        content.text = option.title
        content.secondaryText = option.subtitle
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let option = Option(rawValue: indexPath.row) else { return }
        switch option {
        case .completedHistory:
            let controller = CompletedHistoryViewController(style: .insetGrouped)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
