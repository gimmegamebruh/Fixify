import FirebaseFirestore

final class RequestService {

    static let shared = RequestService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Fetch
    func fetchRequests(completion: @escaping ([Request]) -> Void) {
        db.collection("requests")
            .order(by: "dateCreated", descending: true)
            .addSnapshotListener { snapshot, _ in

                guard let docs = snapshot?.documents else {
                    completion([]) 
                    return
                }

                let requests = docs.compactMap { doc -> Request? in
                    try? doc.data(as: Request.self)
                }

                completion(requests)
            }
    }

    // MARK: - Create
    func createRequest(_ request: Request) throws {
        try db.collection("requests")
            .document(request.id)
            .setData(from: request)
    }

    // MARK: - Update full request
    func updateRequest(_ request: Request) {
        do {
            try db.collection("requests")
                .document(request.id)
                .setData(from: request, merge: true)
        } catch {
            print("❌ Update failed:", error)
        }
    }

    // MARK: - Update status only
    func updateStatus(id: String, status: RequestStatus) {
        db.collection("requests")
            .document(id)
            .updateData([
                "status": status.rawValue
            ])
    }
    
    func submitRating(id: String, rating: Int, comment: String?) {
        db.collection("requests")
            .document(id)
            .updateData([
                "rating": rating,
                "ratingComment": comment ?? ""
            ])
    }

}

