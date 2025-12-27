import Foundation

final class TechnicianMetricsCalculator {

    private let store = RequestStore.shared

    /// Calculates technician metrics using ONLY Request data
    /// - No Firebase writes
    /// - No extra timestamps
    /// - Same logic used everywhere (ASSIGNED + ACTIVE)
    func calculate(
        for technicianID: String,
        completion: @escaping (TechnicianMetrics) -> Void
    ) {

        // All requests assigned to this technician
        let assignedRequests = store.requests.filter {
            $0.assignedTechnicianID == technicianID
        }

        // MARK: - Active jobs (assigned OR active)
        let activeJobs = assignedRequests.filter {
            $0.status == .assigned || $0.status == .active
        }

        // MARK: - Completed jobs
        let completedJobs = assignedRequests.filter {
            $0.status == .completed
        }

        // MARK: - Average completion time (approximate, days)
        let completionDurations: [Double] = completedJobs.map { request in
            Date().timeIntervalSince(request.dateCreated) / 86400.0
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

        // MARK: - Final Metrics
        let metrics = TechnicianMetrics(
            totalJobsCompleted: completedJobs.count,
            pendingJobs: activeJobs.count, // 🔥 ASSIGNED + ACTIVE
            averageCompletionTime: averageCompletionTime,
            customerRating: averageRating,
            totalReviews: ratings.count
        )

        completion(metrics)
    }
}
