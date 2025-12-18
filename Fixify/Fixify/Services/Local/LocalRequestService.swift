import Foundation

final class LocalRequestService: RequestServicing {

    static let shared = LocalRequestService()
    private init() {}

    private var storage: [Request] = DummyRequests.data

    func fetchAll(completion: @escaping ([Request]) -> Void) {
        completion(storage)
    }

    func assignTechnician(
        requestID: String,
        technicianID: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let index = storage.firstIndex(where: { $0.id == requestID }) else {
            completion(false)
            return
        }

        let currentRequest = storage[index]

        // ✅ Only pending / escalated can be assigned or reassigned
        guard currentRequest.status == .pending || currentRequest.status == .escalated else {
            completion(false)
            return
        }

        let oldTechnicianID = currentRequest.assignedTechnicianID

        // 🔁 Reassignment logic
        if let oldID = oldTechnicianID, oldID != technicianID {
            LocalTechnicianService.shared.decrementJobs(for: oldID)
        }

        // 🔺 Increment new technician
        if oldTechnicianID != technicianID {
            LocalTechnicianService.shared.incrementJobs(for: technicianID)
        }

        // ✅ Actually transfer the request
        storage[index].assignedTechnicianID = technicianID

        completion(true)
    }

    func updateRequest(_ request: Request) {
        guard let index = storage.firstIndex(where: { $0.id == request.id }) else { return }
        storage[index] = request
    }
}
