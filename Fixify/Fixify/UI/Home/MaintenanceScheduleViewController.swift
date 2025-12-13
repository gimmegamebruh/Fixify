//
//  MaintenanceScheduleViewController.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import UIKit

final class MaintenanceScheduleViewController: UITableViewController {

    private let dataStore = TechnicianDataStore.shared
    private var jobs: [ScheduledJob] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .systemGroupedBackground
        reload()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: .technicianScheduleDidChange,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        jobs = dataStore.scheduledJobs.sorted(by: { $0.scheduledTime < $1.scheduledTime })
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let job = jobs[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = job.issueType
        let dateString = job.scheduledTime.formatted(dateStyle: .medium, timeStyle: .short)
        content.secondaryText = "\(job.location)\n\(dateString) · \(job.priority.rawValue)"
        content.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}
