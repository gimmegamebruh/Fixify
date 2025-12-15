import Foundation

final class LocalRequestService: RequestServicing {

    static let shared = LocalRequestService()
    private init() {}

    private var storage = DummyRequests.data

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

        storage[index].assignedTechnicianID = technicianID
        storage[index].status = .assigned
        completion(true)
    }

    func updateRequest(_ request: Request) {
        guard let index = storage.firstIndex(where: { $0.id == request.id }) else { return }
        storage[index] = request
    }
}
