import Foundation

final class AssignTechnicianViewModel {

    private let technicianService: TechnicianServicing
    private let store = RequestStore.shared
    private let requestID: String

    private(set) var technicians: [Technician] = []

    init(
        requestID: String,
        technicianService: TechnicianServicing = LocalTechnicianService.shared
    ) {
        self.requestID = requestID
        self.technicianService = technicianService
    }

    // MARK: - Load (with completion so VC can reload)
    func load(completion: @escaping () -> Void) {

        technicianService.fetchAll { [weak self] techs in
            guard let self else { return }
            self.technicians = techs

            DispatchQueue.main.async {
                completion()
            }
        }
    }

    // Always fetch the latest request from the store
    private func currentRequest() -> Request? {
        store.requests.first(where: { $0.id == requestID })
    }

    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isCurrentlyAssigned(_ technician: Technician) -> Bool {
        currentRequest()?.assignedTechnicianID == technician.id
    }

    // MARK: - Assign (🔥 GUARANTEED)
    func assignTechnician(_ technician: Technician, completion: @escaping (Bool) -> Void) {

        guard var request = currentRequest() else {
            print("❌ Assign failed: Request not found in store for id:", requestID)
            completion(false)
            return
        }

        print("✅ Tapped assign for tech:", technician.id, "on request:", request.id)

        request.assignedTechnicianID = technician.id
        request.status = .active   // ✅ MUST become active

        store.updateRequest(request)

        completion(true)
    }
}
