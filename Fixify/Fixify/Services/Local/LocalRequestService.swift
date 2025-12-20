import Foundation

final class LocalRequestService: RequestServicing {

    static let shared = LocalRequestService()
    private init() {}

    private var storage: [Request] = DummyRequests.data

    // MARK: - Fetch
    func fetchAll(completion: @escaping ([Request]) -> Void) {
        autoEscalateOverdueRequests()
        completion(storage)
    }

    // MARK: - Assign / Reassign Technician
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

        // ✅ If admin taps the same technician again, do nothing (and don't change counts)
        guard oldTechnicianID != technicianID else {
            completion(false)
            return
        }

        // 🔁 Reassignment logic (decrement old tech if there was one)
        if let oldID = oldTechnicianID {
            LocalTechnicianService.shared.decrementJobs(for: oldID)
        }

        // 🔺 Increment new technician
        LocalTechnicianService.shared.incrementJobs(for: technicianID)

        // ✅ Actually transfer the request
        storage[index].assignedTechnicianID = technicianID

        completion(true)
    }

    // MARK: - Update Request
    func updateRequest(_ request: Request) {
        guard let index = storage.firstIndex(where: { $0.id == request.id }) else { return }
        storage[index] = request
    }

    // MARK: - Auto Escalation (14 days)
    private func autoEscalateOverdueRequests() {
        let now = Date()

        for index in storage.indices {
            let request = storage[index]

            // ❌ Never escalate completed requests
            guard request.status != .completed else { continue }

            let daysOpen = Calendar.current.dateComponents(
                [.day],
                from: request.dateCreated,
                to: now
            ).day ?? 0

            // ✅ Escalate if open >= 14 days (and not already escalated)
            if daysOpen >= 14 && request.status != .escalated {
                storage[index].status = .escalated
            }
        }
    }
}
