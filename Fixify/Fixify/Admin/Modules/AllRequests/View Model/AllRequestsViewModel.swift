import Foundation

final class AllRequestsViewModel {

    private let store = RequestStore.shared

    // MARK: - Source of Truth (Firebase-backed)
    private var requests: [Request] {
        store.requests
    }

    // MARK: - Admin Requests (exclude escalated)
    var allRequests: [Request] {
        requests.filter { $0.status != .escalated }
    }

    // MARK: - Filters
    func filtered(_ filter: RequestFilter) -> [Request] {
        switch filter {
        case .lastWeek:
            return allRequests.filter { $0.dateCreated.isWithinLastWeek }

        case .lastMonth:
            return allRequests.filter { $0.dateCreated.isWithinLastMonth }

        case .lastYear:
            return allRequests.filter { $0.dateCreated.isWithinLastYear }

        case .allTime:
            return allRequests
        }
    }
}
