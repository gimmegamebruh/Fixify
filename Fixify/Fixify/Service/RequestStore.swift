import Foundation

final class RequestStore {

    static let shared = RequestStore()

    private(set) var requests: [Request] = []
    private let service = RequestService.shared

    private init() {
        listen()
    }

    private func listen() {
        service.fetchRequests { [weak self] fetched in
            DispatchQueue.main.async {
                self?.requests = fetched
                NotificationCenter.default.post(
                    name: .technicianRequestsDidChange,
                    object: nil
                )
            }
        }
    }

    // MARK: - Create
    func add(_ request: Request) {
        do {
            try service.createRequest(request)
        } catch {
            print("❌ Create failed:", error)
        }
    }

    func updateRequest(_ request: Request) {

        if let idx = requests.firstIndex(where: { $0.id == request.id }) {
            requests[idx] = request
        } else {
            requests.insert(request, at: 0)
        }

        NotificationCenter.default.post(
            name: .technicianRequestsDidChange,
            object: nil
        )

        service.updateRequest(request)
    }

    // MARK: - Status
    func updateStatus(id: String, status: RequestStatus) {

        if let index = requests.firstIndex(where: { $0.id == id }) {
            requests[index].status = status
        }

        NotificationCenter.default.post(
            name: .technicianRequestsDidChange,
            object: nil
        )

        service.updateStatus(id: id, status: status)
    }


    func submitRating(requestID: String, rating: Int, comment: String?) {
        service.submitRating(id: requestID, rating: rating, comment: comment)
    }
}
