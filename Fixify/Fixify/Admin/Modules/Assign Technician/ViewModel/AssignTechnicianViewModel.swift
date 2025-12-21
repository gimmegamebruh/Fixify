//
//  AssignTechnicianViewModel.swift
//  Fixify
//

import Foundation

final class AssignTechnicianViewModel {

    private let technicianService: TechnicianServicing
    private let requestStore = RequestStore.shared

    private(set) var technicians: [Technician] = []
    private let requestID: String
    private var currentRequest: Request?

    init(
        requestID: String,
        technicianService: TechnicianServicing = LocalTechnicianService.shared
    ) {
        self.requestID = requestID
        self.technicianService = technicianService
    }

    // MARK: - Load

    func load() {
        technicianService.fetchAll { [weak self] techs in
            self?.technicians = techs
        }

        currentRequest = requestStore.requests.first {
            $0.id == requestID
        }
    }

    // MARK: - Helpers

    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isBusy(_ technician: Technician) -> Bool {
        false // 🔓 multiple assignments allowed (for now)
    }

    func isCurrentlyAssigned(_ technician: Technician) -> Bool {
        currentRequest?.assignedTechnicianID == technician.id
    }

    // MARK: - Assign

    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        guard var request = currentRequest else {
            completion(false)
            return
        }

        guard request.assignedTechnicianID != technician.id else {
            completion(false)
            return
        }

        // ✅ Update request
        request.assignedTechnicianID = technician.id
        request.status = .active

        // 🔥 Firebase update (LIVE)
        RequestStore.shared.updateRequest(request)

        completion(true)
    }
}
