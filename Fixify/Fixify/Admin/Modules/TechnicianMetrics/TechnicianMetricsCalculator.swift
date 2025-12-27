import Foundation

final class TechnicianMetricsCalculator {

    private let store = RequestStore.shared

    /// Calculates technician metrics using ONLY existing Request fields.
    /// - Uses status + dateCreated
    /// - No Firebase schema changes
    /// - No lifecycle timestamps required
    func calculate(
        for technicianID: String,
        completion: @escaping (TechnicianMetrics) -> Void
    ) {

        // Requests assigned to this technician
        let assignedRequests = store.requests.filter {
            $0.assignedTechnicianID == technicianID
        }

        // MARK: - Active jobs (currently being worked on)
        let activeJobs = assignedRequests.filter {
            $0.status == .active
        }

        // MARK: - Pending jobs (assigned but not started)
        let pendingJobs = assignedRequests.filter {
            $0.status == .assigned
        }

        // MARK: - Completed jobs
        let completedJobs = assignedRequests.filter {
            $0.status == .completed
        }

        // MARK: - Average completion time (APPROXIMATE)
        // Uses Date() - dateCreated
        let completionDurations: [Double] = completedJobs.map { request in
            let seconds = Date().timeIntervalSince(request.dateCreated)
            return seconds / 86400.0 // seconds → days
        }

        let averageCompletionTime: Double
        if completionDurations.isEmpty {
            averageCompletionTime = 0
        } else {
            averageCompletionTime =
                completionDurations.reduce(0, +) / Double(completionDurations.count)
        }

        // MARK: - Ratings
        let ratings = completedJobs.compactMap { $0.rating }
        let averageRating: Double
        if ratings.isEmpty {
            averageRating = 0
        } else {
            averageRating =
                Double(ratings.reduce(0, +)) / Double(ratings.count)
        }

        let metrics = TechnicianMetrics(
            totalJobsCompleted: completedJobs.count,
            pendingJobs: pendingJobs.count,
            averageCompletionTime: averageCompletionTime,
            customerRating: averageRating,
            totalReviews: ratings.count
        )

        completion(metrics)
    }
}
