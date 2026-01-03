import Foundation

final class ManageTechnicianViewModel {

    private let technicianService: TechnicianServicing
    private let requestStore = RequestStore.shared

    private(set) var technicians: [Technician] = []
    private let requestID: String
    private var currentRequest: Request?

    var onUpdate: (() -> Void)?

    init(
        requestID: String,
        technicianService: TechnicianServicing = FirebaseTechnicianService.shared
    ) {
        self.requestID = requestID
        self.technicianService = technicianService
    }

    // MARK: - Load

    func load() {

        currentRequest = requestStore.requests.first {
            $0.id == requestID
        }

        technicianService.fetchAll { [weak self] techs in
            guard let self else { return }

            self.technicians = techs.map { technician in
                var tech = technician
                tech.activeJobs = self.jobCount(for: technician.id)
                return tech
            }

            self.onUpdate?()
        }
    }

    // MARK: - Helpers

    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isCurrentlyAssigned(_ technician: Technician) -> Bool {
        currentRequest?.assignedTechnicianID == technician.id
    }

    private func jobCount(for technicianID: String) -> Int {
        requestStore.requests.filter {
            $0.assignedTechnicianID == technicianID &&
            ($0.status == .assigned || $0.status == .active)
        }.count
    }

    // MARK: - Assignment (🔥 FIXED)

    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        guard var request = currentRequest else {
            completion(false)
            return
        }

        request.assignedTechnicianID = technician.id
        request.status = .assigned

        // 🔥 IMPORTANT: keep local reference in sync
        currentRequest = request

        // 🔥 Optimistic update
        requestStore.updateRequest(request)

        completion(true)
    }
}
