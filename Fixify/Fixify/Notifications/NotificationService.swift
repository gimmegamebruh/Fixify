//
//  NotificationService.swift
//  Fixify
//
//  Created by Codex on 23/11/2025.
//

import Foundation

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func notifyStakeholders(for request: MaintenanceRequest) {
        let payload = """
        Dispatching notifications:
        • Student updated on status (\(request.status.rawValue))
        • Admin copied on technician update
        • Request \(request.id) persisted
        """
        NSLog(payload)
    }
}
