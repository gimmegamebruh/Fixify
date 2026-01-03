import Foundation

final class AdminDashboardViewModel {

    private let store = RequestStore.shared

    private var requests: [Request] {
        store.requests
    }

    // MARK: - Stats Cards

    var totalRequests: Int {
        requests.count
    }

    var completedRequests: Int {
        requests.filter { $0.status == .completed }.count
    }

    var pendingRequests: Int {
        requests.filter {
            $0.status == .pending
        }.count
    }

    var escalatedRequests: [Request] {
        requests.filter { $0.status == .escalated }
    }

    var averageCompletionText: String {

        let completionDays: [Int] = requests
            .filter { $0.status == .completed }
            .map {
                Calendar.current.dateComponents(
                    [.day],
                    from: $0.dateCreated,
                    to: Date()
                ).day ?? 0
            }

        guard !completionDays.isEmpty else {
            return "0d"
        }

        let average = completionDays.reduce(0, +) / completionDays.count
        return "\(average)d"
    }
}
