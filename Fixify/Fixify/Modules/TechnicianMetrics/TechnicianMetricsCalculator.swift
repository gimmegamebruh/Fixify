//
//  TechnicianMetricsCalculator.swift
//  Fixify
//

import Foundation

final class TechnicianMetricsCalculator {

    private let requestService: RequestServicing

    init(requestService: RequestServicing = LocalRequestService.shared) {
        self.requestService = requestService
    }

    func calculate(
        for technicianID: String,
        completion: @escaping (TechnicianMetrics) -> Void
    ) {
        requestService.fetchAll { requests in

            let assigned = requests.filter {
                $0.assignedTechnicianID == technicianID
            }

            let completed = assigned.filter { $0.status == .completed }
            let pending = assigned.filter { $0.status == .pending }

            let completionDays: [Int] = completed.compactMap {
                guard let completedDate = $0.completedDate else { return nil }
                return Calendar.current.dateComponents(
                    [.day],
                    from: $0.dateCreated,
                    to: completedDate
                ).day
            }

            let avgTime = completionDays.isEmpty
                ? 0
                : completionDays.reduce(0, +) / completionDays.count

            let metrics = TechnicianMetrics(
                totalJobsCompleted: completed.count,
                pendingJobs: pending.count,
                averageCompletionTime: Double(avgTime),
                customerRating: 0,   // comes later from reviews
                totalReviews: 0
            )

            completion(metrics)
        }
    }
}
