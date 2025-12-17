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

    // MARK: - Load (🔥 THIS IS WHAT WAS MISSING)
    func load() {
        technicianService.fetchAll { [weak self] techs in
            guard let self else { return }
            self.technicians = techs.sorted {
                $0.activeJobs < $1.activeJobs
            }
        }
    }

    // MARK: - Access
    func technician(at index: Int) -> Technician {
        technicians[index]
    }

    func isBusy(_ technician: Technician) -> Bool {
        technician.activeJobs > 0
    }

    // MARK: - Assign
    func assignTechnician(
        _ technician: Technician,
        completion: @escaping (Bool) -> Void
    ) {
        guard !isBusy(technician) else {
            completion(false)
            return
        }

        requestService.assignTechnician(
            requestID: requestID,
            technicianID: technician.id
        ) { success in
            if success {
                LocalTechnicianService.shared.incrementJobs(for: technician.id)
            }
            completion(success)
        }
    }
}
