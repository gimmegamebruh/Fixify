//
//  CompletedHistoryViewController.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class CompletedHistoryViewController: UITableViewController {

    private let dataStore = TechnicianDataStore.shared
    private var records: [CompletedRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Completed"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completed")
        tableView.backgroundColor = .systemGroupedBackground
        reload()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: .technicianHistoryDidChange,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        records = dataStore.completedRecords
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completed", for: indexPath)
        let record = records[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = record.title

        let minutes = Int(record.resolutionTime / 60)
        let secondary = "\(record.location)\nResolution: \(minutes) min · ⭐️\(record.starRating)"
        content.secondaryText = secondary
        content.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}
