import FirebaseFirestore

protocol TechnicianServicing {
    func fetchAll(completion: @escaping ([Technician]) -> Void)
    func name(for technicianID: String, completion: @escaping (String?) -> Void)
}

final class FirebaseTechnicianService: TechnicianServicing {

    static let shared = FirebaseTechnicianService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Fetch all technicians
    func fetchAll(completion: @escaping ([Technician]) -> Void) {

        db.collection("users")
            .whereField("role", isEqualTo: "technician")
            .addSnapshotListener { snapshot, error in

                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }

                let technicians: [Technician] = docs.compactMap { doc in
                    let data = doc.data()

                    guard
                        let name = data["name"] as? String,
                        let email = data["email"] as? String
                    else { return nil }

                    return Technician(
                        id: doc.documentID,
                        name: name,
                        email: email,
                        specialization: data["specialization"] as? String ?? "General Technician",
                        activeJobs: 0,          // calculated dynamically
                        isActive: true,
                        avatarName: nil
                    )
                }

                completion(technicians)
            }
    }

    // MARK: - Get technician name (async, safe)
    func name(for technicianID: String, completion: @escaping (String?) -> Void) {

        db.collection("users")
            .document(technicianID)
            .getDocument { snapshot, _ in
                let name = snapshot?.data()?["name"] as? String
                completion(name)
            }
    }
}
