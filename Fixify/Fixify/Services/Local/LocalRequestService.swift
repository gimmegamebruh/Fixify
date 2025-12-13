final class LocalRequestService: RequestServicing {

    private var storage = DummyRequests.data

    func fetchAll(completion: @escaping ([Request]) -> Void) {
        completion(storage)
    }

    func assignTechnician(requestID: String, technicianID: String, completion: @escaping (Bool) -> Void) {
        if let index = storage.firstIndex(where: { $0.id == requestID }) {
            storage[index].assignedTechnicianID = technicianID
            storage[index].status = .assigned
            completion(true)
        } else {
            completion(false)
        }
    }
}
