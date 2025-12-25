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

    func load() {
        technicianService.fetchAll { [weak self] techs in
            self?.technicians = techs
        }

        currentRequest = requestStore.requests.first {
            $0.id == requestID
        }
    }

    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isCurrentlyAssigned(_ technician: Technician) -> Bool {
        currentRequest?.assignedTechnicianID == technician.id
    }

    // 🔥 CORE LOGIC
    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        guard var request = currentRequest else {
            completion(false)
            return
        }

        guard request.status.canAssignTechnician else {
            completion(false)
            return
        }

        request.assignedTechnicianID = technician.id

        // ✅ ALWAYS MOVE TO ASSIGNED (NOT ACTIVE)
        request.status = .assigned

        RequestStore.shared.updateRequest(request)
        completion(true)
    }
}
