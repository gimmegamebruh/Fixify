//
//  TechnicianDataStore.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import Foundation

enum MaintenanceFilter: Int, CaseIterable {
    case all
    case active
    case pending
    case completed

    var title: String {
        switch self {
        case .all:
            return "All"
        case .active:
            return "Active"
        case .pending:
            return "Pending"
        case .completed:
            return "Completed"
        }
    }
}

extension Notification.Name {
    static let technicianRequestsDidChange = Notification.Name("TechnicianRequestsDidChange")
    static let technicianScheduleDidChange = Notification.Name("TechnicianScheduleDidChange")
    static let technicianHistoryDidChange = Notification.Name("TechnicianHistoryDidChange")
}

final class TechnicianDataStore {
    static let shared = TechnicianDataStore()

    private(set) var requests: [MaintenanceRequest] = []
    private(set) var scheduledJobs: [ScheduledJob] = []
    private(set) var completedRecords: [CompletedRecord] = []

    private let notificationCenter: NotificationCenter
    private let notificationService: NotificationService

    private init(notificationCenter: NotificationCenter = .default,
                 notificationService: NotificationService = .shared) {
        self.notificationCenter = notificationCenter
        self.notificationService = notificationService
        bootstrapData()
    }

    func requests(for filter: MaintenanceFilter) -> [MaintenanceRequest] {
        switch filter {
        case .all:
            return requests
        case .active:
            return requests.filter { $0.status == .inProgress }
        case .pending:
            return requests.filter { $0.status == .pending }
        case .completed:
            return requests.filter { $0.status == .completed }
        }
    }

    func request(with id: String) -> MaintenanceRequest? {
        return requests.first { $0.id == id }
    }

    func updateStatus(for requestID: String, to newStatus: MaintenanceStatus) {
        guard let index = requests.firstIndex(where: { $0.id == requestID }) else { return }
        requests[index].status = newStatus

        if newStatus == .completed {
            ensureCompletedRecord(for: requests[index])
            scheduledJobs.removeAll { $0.requestID == requestID }
        }

        notificationService.notifyStakeholders(for: requests[index])
        broadcastUpdates()
    }

    func markRequestInProgress(_ requestID: String) {
        updateStatus(for: requestID, to: .inProgress)
    }

    func markRequestCompleted(_ requestID: String) {
        updateStatus(for: requestID, to: .completed)
    }

    func addScheduleEntry(for requestID: String, at scheduledTime: Date) {
        guard let request = request(with: requestID) else { return }
        requests = requests.map { req in
            var mutableReq = req
            if req.id == requestID {
                mutableReq.scheduledTime = scheduledTime
            }
            return mutableReq
        }

        let job = ScheduledJob(requestID: requestID,
                               issueType: request.title,
                               location: request.location,
                               scheduledTime: scheduledTime,
                               priority: request.priority)
        scheduledJobs.append(job)
        scheduledJobs.sort { $0.scheduledTime < $1.scheduledTime }
        notificationCenter.post(name: .technicianScheduleDidChange, object: nil)
    }

    private func ensureCompletedRecord(for request: MaintenanceRequest) {
        guard completedRecords.contains(where: { $0.title == request.title && $0.location == request.location }) == false else { return }
        let resolution = CompletedRecord(title: request.title,
                                         location: request.location,
                                         resolutionTime: 60 * 60,
                                         starRating: Int.random(in: 4...5))
        completedRecords.insert(resolution, at: 0)
    }

    private func broadcastUpdates() {
        notificationCenter.post(name: .technicianRequestsDidChange, object: nil)
        notificationCenter.post(name: .technicianScheduleDidChange, object: nil)
        notificationCenter.post(name: .technicianHistoryDidChange, object: nil)
    }

    private func bootstrapData() {
        let snapshot = TechnicianDataProvider.templateSnapshot()
        requests = snapshot.requests
        completedRecords = snapshot.completedRecords

        scheduledJobs = snapshot.requests.compactMap { request in
            guard let scheduledTime = request.scheduledTime else { return nil }
            return ScheduledJob(requestID: request.id,
                                issueType: request.title,
                                location: request.location,
                                scheduledTime: scheduledTime,
                                priority: request.priority)
        }.sorted { $0.scheduledTime < $1.scheduledTime }
    }
}
