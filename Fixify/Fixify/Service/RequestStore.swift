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

    // MARK: - Update
    func updateRequest(_ request: Request) {
        service.updateRequest(request)
    }

    // MARK: - Status
    func updateStatus(id: String, status: RequestStatus) {
        service.updateStatus(id: id, status: status)
    }
    
    func submitRating(requestID: String, rating: Int, comment: String?) {
        service.submitRating(id: requestID, rating: rating, comment: comment)
    }

}

