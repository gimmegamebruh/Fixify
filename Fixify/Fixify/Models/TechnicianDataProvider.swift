//
//  TechnicianDataProvider.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import Foundation

enum MaintenancePriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
}

enum MaintenanceStatus: String, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"

    var allowsMarkAsCompleted: Bool {
        switch self {
        case .pending, .inProgress:
            return true
        case .completed:
            return false
        }
    }
}

struct MaintenanceRequest: Identifiable {
    let id: String
    let title: String
    let description: String
    let location: String
    let submissionDate: Date
    let priority: MaintenancePriority
    var status: MaintenanceStatus
    let imageName: String?
    var scheduledTime: Date?

    init(id: String,
         title: String,
         description: String,
         location: String,
         submissionDate: Date,
         priority: MaintenancePriority,
         status: MaintenanceStatus,
         imageName: String? = nil,
         scheduledTime: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.location = location
        self.submissionDate = submissionDate
        self.priority = priority
        self.status = status
        self.imageName = imageName
        self.scheduledTime = scheduledTime
    }
}

struct ScheduledJob: Identifiable {
    let id: UUID = UUID()
    let requestID: String
    let issueType: String
    let location: String
    let scheduledTime: Date
    let priority: MaintenancePriority
}

struct CompletedRecord: Identifiable {
    let id: UUID = UUID()
    let title: String
    let location: String
    let resolutionTime: TimeInterval
    let starRating: Int
}

struct TechnicianDataSnapshot {
    let requests: [MaintenanceRequest]
    let completedRecords: [CompletedRecord]
}

enum TechnicianDataProvider {

    static func templateSnapshot(referenceDate: Date = Date()) -> TechnicianDataSnapshot {
        let requests = templateRequests(referenceDate: referenceDate)
        let completedRecords = templateCompletedRecords()
        return TechnicianDataSnapshot(requests: requests, completedRecords: completedRecords)
    }

    private static func templateRequests(referenceDate: Date) -> [MaintenanceRequest] {
        return [
            MaintenanceRequest(id: "REQ-1021",
                               title: "Leaky Faucet",
                               description: "Student reported a faucet that will not stop dripping in Dorm A room 203. Requires cartridge replacement.",
                               location: "Dorm A · 203",
                               submissionDate: referenceDate.addingTimeInterval(-60 * 60 * 20),
                               priority: .medium,
                               status: .pending,
                               imageName: "drop.fill",
                               scheduledTime: referenceDate.addingTimeInterval(60 * 60 * 4)),
            MaintenanceRequest(id: "REQ-1034",
                               title: "Power Outlet Failure",
                               description: "Outlet sparks when plugging devices. Shut breaker 4B until resolved.",
                               location: "Engineering Lab · 1F",
                               submissionDate: referenceDate.addingTimeInterval(-60 * 60 * 48),
                               priority: .high,
                               status: .inProgress,
                               imageName: "bolt.fill",
                               scheduledTime: referenceDate.addingTimeInterval(60 * 60 * 2)),
            MaintenanceRequest(id: "REQ-1050",
                               title: "HVAC Noise",
                               description: "Loud banging noise reported when system starts each morning.",
                               location: "Library · Roof",
                               submissionDate: referenceDate.addingTimeInterval(-60 * 60 * 72),
                               priority: .urgent,
                               status: .pending,
                               imageName: "fan.fill",
                               scheduledTime: referenceDate.addingTimeInterval(60 * 60 * 30)),
            MaintenanceRequest(id: "REQ-1062",
                               title: "Broken Window Latch",
                               description: "Latch missing, classroom cannot be secured overnight.",
                               location: "Science Hall · 2F",
                               submissionDate: referenceDate.addingTimeInterval(-60 * 60 * 10),
                               priority: .low,
                               status: .completed,
                               imageName: "rectangle.portrait",
                               scheduledTime: referenceDate.addingTimeInterval(-60 * 60 * 2))
        ]
    }

    private static func templateCompletedRecords() -> [CompletedRecord] {
        return [
            CompletedRecord(title: "Window Latch",
                            location: "Science Hall · 2F",
                            resolutionTime: 60 * 25,
                            starRating: 5)
        ]
    }
}

extension Date {
    func formatted(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
