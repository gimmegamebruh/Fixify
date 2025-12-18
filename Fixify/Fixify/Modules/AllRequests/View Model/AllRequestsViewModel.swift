import Foundation

final class AllRequestsViewModel {

    private let service: RequestServicing = LocalRequestService.shared
    private(set) var allRequests: [Request] = []

    func load() {
        service.fetchAll { [weak self] requests in
            guard let self else { return }

            // 🔥 EXCLUDE escalated requests
            self.allRequests = requests.filter {
                $0.status != .escalated
            }
        }
    }

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
