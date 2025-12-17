import Foundation

final class LocalTechnicianService: TechnicianServicing {

    static let shared = LocalTechnicianService()

    private init() {
        technicians = DummyTechnicians.data
    }

    private var technicians: [Technician]

    // MARK: - Fetch

    func fetchAll(completion: @escaping ([Technician]) -> Void) {
        completion(technicians)
    }

    // MARK: - Job Management

    func incrementJobs(for technicianID: String) {
        guard let index = technicians.firstIndex(where: { $0.id == technicianID }) else {
            return
        }
        technicians[index].activeJobs += 1
    }

    func decrementJobs(for technicianID: String) {
        guard let index = technicians.firstIndex(where: { $0.id == technicianID }) else {
            return
        }
        technicians[index].activeJobs = max(0, technicians[index].activeJobs - 1)
    }
}
