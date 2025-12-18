//
//  AssignTechnicianViewModel.swift
//  Fixify
//

import Foundation

final class AssignTechnicianViewModel {

    private let technicianService: TechnicianServicing
    private let requestService: RequestServicing

    private(set) var technicians: [Technician] = []
    private let requestID: String
    private var currentRequest: Request?

    init(
        requestID: String,
        technicianService: TechnicianServicing = LocalTechnicianService.shared,
        requestService: RequestServicing = LocalRequestService.shared
    ) {
        self.requestID = requestID
        self.technicianService = technicianService
        self.requestService = requestService
    }

    func load() {
        technicianService.fetchAll { [weak self] techs in
            self?.technicians = techs
        }

        requestService.fetchAll { [weak self] requests in
            self?.currentRequest = requests.first { $0.id == self?.requestID }
        }
    }

    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isBusy(_ technician: Technician) -> Bool {
        false // 🔓 multiple assignments allowed
    }

    func isCurrentlyAssigned(_ technician: Technician) -> Bool {
        currentRequest?.assignedTechnicianID == technician.id
    }

    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        guard !isCurrentlyAssigned(technician) else {
            completion(false)
            return
        }

        requestService.assignTechnician(
            requestID: requestID,
            technicianID: technician.id
        ) { success in
            completion(success)
        }
    }
}
