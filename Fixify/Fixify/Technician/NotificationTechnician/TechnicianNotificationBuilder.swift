//
//  TechnicianNotificationBuilder.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import Foundation

enum TechnicianNotificationBuilder {

    static func build(
        from requests: [Request],
        technicianID: String?
    ) -> [TechnicianNotification] {

        guard let technicianID else { return [] }

        return requests.compactMap { request in
            guard request.assignedTechnicianID == technicianID else {
                return nil
            }

            switch request.status {

            case .assigned:
                return TechnicianNotification(
                    id: "assign-\(request.id)",
                    requestID: request.id,
                    title: "New Assignment",
                    subtitle: request.title,
                    date: request.dateCreated,
                    type: .assigned
                )

            case .active:
                if let scheduled = request.scheduledTime {
                    return TechnicianNotification(
                        id: "scheduled-\(request.id)",
                        requestID: request.id,
                        title: "Job Scheduled",
                        subtitle: request.title,
                        date: scheduled,
                        type: .scheduled
                    )
                }
                return nil

            case .completed:
                return TechnicianNotification(
                    id: "complete-\(request.id)",
                    requestID: request.id,
                    title: "Job Completed",
                    subtitle: request.title,
                    date: request.scheduledTime ?? request.dateCreated,
                    type: .completed
                )

            default:
                return nil
            }
        }
        .sorted { $0.date > $1.date }
    }
}
