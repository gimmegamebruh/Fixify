import Foundation

final class AssignTechnicianViewModel {

    // MARK: - Dependencies
    private let technicianService: TechnicianServicing
    private let requestService: RequestServicing

    // MARK: - State
    private(set) var technicians: [Technician] = []
    private let requestID: String

    // MARK: - Init
    init(
        requestID: String,
        technicianService: TechnicianServicing = LocalTechnicianService.shared,
        requestService: RequestServicing = LocalRequestService.shared
    ) {
        self.requestID = requestID
        self.technicianService = technicianService
        self.requestService = requestService
    }

    // MARK: - Load
    func load() {
        technicianService.fetchAll { [weak self] techs in
            self?.technicians = techs
        }
    }

    // MARK: - Access
    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    // 🔥 IMPORTANT: No more "busy" logic
    func isBusy(_ technician: Technician) -> Bool {
        return false
    }

    // MARK: - Assign
    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        requestService.assignTechnician(
            requestID: requestID,
            technicianID: technician.id,
            completion: completion
        )
    }
}
