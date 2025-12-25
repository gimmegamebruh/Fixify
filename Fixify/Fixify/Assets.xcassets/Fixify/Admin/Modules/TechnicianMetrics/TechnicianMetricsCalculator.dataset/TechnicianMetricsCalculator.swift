//
//  TechnicianMetricsCalculator.swift
//  Fixify
//

import Foundation

final class TechnicianMetricsCalculator {

    private let store = RequestStore.shared

    func calculate(
        for technicianID: String,
        completion: @escaping (TechnicianMetrics) -> Void
    ) {
        let requests = store.requests

        let assignedRequests = requests.filter {
            $0.assignedTechnicianID == technicianID
        }

        let completedRequests = assignedRequests.filter {
            $0.status == .completed
        }

        let pendingRequests = assignedRequests.filter {
            $0.status == .pending || $0.status == .active
        }

        // ⏱ Estimate completion time
        let completionDays: [Int] = completedRequests.map {
            Calendar.current.dateComponents(
                [.day],
                from: $0.dateCreated,
                to: Date()
            ).day ?? 0
        }

        let averageCompletionTime = completionDays.isEmpty
            ? 0
            : completionDays.reduce(0, +) / completionDays.count

        let metrics = TechnicianMetrics(
            totalJobsCompleted: completedRequests.count,
            pendingJobs: pendingRequests.count,
            averageCompletionTime: Double(averageCompletionTime),
            customerRating: 0,   // later from reviews
            totalReviews: 0
        )

        completion(metrics)
    }
}
