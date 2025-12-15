//
//  EscalatedRequestsViewModel.swift
//  Fixify
//
//  Created by BP-36-213-03 on 15/12/2025.
//


import Foundation

final class EscalatedRequestsViewModel {

    private(set) var escalatedRequests: [Request] = []

    func loadData() {
        escalatedRequests = DummyRequests.data.filter {
            $0.status == .escalated
        }
    }
    
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
                Calendar.current.dateComponents(
                    [.day],
                    from: $0.dateCreated,
                    to: Date()
                ).day ?? 0 > 5
            }

        case .urgent:
            return escalatedRequests.filter {
                $0.priority.lowercased() == "high"
            }
        }
    }
}
