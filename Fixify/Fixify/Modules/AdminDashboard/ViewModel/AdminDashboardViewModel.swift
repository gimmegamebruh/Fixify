import Foundation

final class AdminDashboardViewModel {

    private let service = LocalRequestService.shared
    private(set) var requests: [Request] = []

    init() {
        reload()
    }

    func reload() {
        service.fetchAll { [weak self] data in
            self?.requests = data
        }
    }

    var totalRequests: Int { requests.count }

    var completedRequests: Int {
        requests.filter { $0.status == .completed }.count
    }

    var pendingRequests: Int {
        requests.filter { $0.status == .pending }.count
    }

    var averageCompletionText: String {
        let days: [Int] = requests.compactMap { request -> Int? in
            guard
                request.status == .completed,
                let completed = request.completedDate
            else {
                return nil
            }

            return Calendar.current.dateComponents(
                [.day],
                from: request.dateCreated,
                to: completed
            ).day
        }

        guard !days.isEmpty else { return "0d" }
        return "\(days.reduce(0, +) / days.count)d"
    }

    var escalatedRequests: [Request] {
        requests.filter { $0.status == .escalated }
    }
}
