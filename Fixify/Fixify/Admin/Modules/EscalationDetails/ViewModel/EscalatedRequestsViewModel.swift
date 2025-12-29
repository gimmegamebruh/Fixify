import Foundation

final class EscalatedRequestsViewModel {

    private let store = RequestStore.shared
    private(set) var escalatedRequests: [Request] = []

    func loadData() {
        escalatedRequests = store.requests.filter {
            $0.status == .escalated
        }
    }

    func type(for request: Request) -> EscalationFilter? {

        let daysOld = Calendar.current.dateComponents(
            [.day],
            from: request.dateCreated,
            to: Date()
        ).day ?? 0

        if daysOld > 5 {
            return .overdue
        }

        if request.priority == .high || request.priority == .urgent {
            return .urgent
        }

        return nil
    }

    func filtered(by filter: EscalationFilter) -> [Request] {
        switch filter {
        case .all:
            return escalatedRequests
        case .overdue:
            return escalatedRequests.filter { type(for: $0) == .overdue }
        case .urgent:
            return escalatedRequests.filter { type(for: $0) == .urgent }
        }
    }
}
