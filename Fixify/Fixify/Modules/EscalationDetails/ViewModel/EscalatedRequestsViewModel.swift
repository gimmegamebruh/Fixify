//
//  EscalatedRequestsViewModel.swift
//  Fixify
//

import Foundation

final class EscalatedRequestsViewModel {

    private let service: RequestServicing = LocalRequestService.shared
    private(set) var escalatedRequests: [Request] = []

    func loadData() {
        service.fetchAll { [weak self] requests in
            guard let self else { return }
            self.escalatedRequests = requests.filter { $0.status == .escalated } // ✅ only escalated
        }
    }

    // ✅ This is what your ViewController needs
    func type(for request: Request) -> EscalationFilter {
        let daysOld = Calendar.current.dateComponents(
            [.day],
            from: request.dateCreated,
            to: Date()
        ).day ?? 0

        if daysOld > 5 {
            return .overdue
        } else if request.priority.lowercased() == "high" {
            return .urgent
        } else {
            return .all
        }
    }

    func filtered(by filter: EscalationFilter) -> [Request] {
        switch filter {
        case .all:
            return escalatedRequests

        case .overdue:
            return escalatedRequests.filter {
                (Calendar.current.dateComponents([.day], from: $0.dateCreated, to: Date()).day ?? 0) > 5
            }

        case .urgent:
            return escalatedRequests.filter {
                $0.priority.lowercased() == "high"
            }
        }
    }
}
