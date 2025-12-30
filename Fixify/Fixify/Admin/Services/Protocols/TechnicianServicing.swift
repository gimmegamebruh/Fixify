import FirebaseFirestore
import FirebaseAuth
import Firebase

extension Auth {
    static func secondary() -> Auth {

        let appName = "SecondaryAuth"

        // Reuse if already created
        if let app = FirebaseApp.app(name: appName) {
            return Auth.auth(app: app)
        }

        // Create secondary Firebase app
        guard let primary = FirebaseApp.app() else {
            fatalError("Primary Firebase app not configured")
        }

        FirebaseApp.configure(name: appName, options: primary.options)

        guard let secondaryApp = FirebaseApp.app(name: appName) else {
            fatalError("Unable to create secondary Firebase app")
        }

        return Auth.auth(app: secondaryApp)
    }
}
protocol TechnicianServicing {
    func fetchAll(completion: @escaping ([Technician]) -> Void)
    func name(for technicianID: String, completion: @escaping (String?) -> Void)

    func update(
        technician: Technician,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func createTechnician(
        name: String,
        email: String,
        password: String,
        specialization: String,
        extraData: [String: Any],
        completion: @escaping (Result<Technician, Error>) -> Void
    )
}

final class FirebaseTechnicianService: TechnicianServicing {

    static let shared = FirebaseTechnicianService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Fetch
    func fetchAll(completion: @escaping ([Technician]) -> Void) {
        db.collection("users")
            .whereField("role", isEqualTo: "technician")
            .addSnapshotListener { snap, _ in

                guard let docs = snap?.documents else {
                    completion([])
                    return
                }

                let technicians = docs.compactMap { doc -> Technician? in
                    let d = doc.data()
                    guard
                        let name = d["name"] as? String,
                        let email = d["email"] as? String
                    else { return nil }

                    return Technician(
                        id: doc.documentID,
                        name: name,
                        email: email,
                        specialization: d["specialization"] as? String ?? "General",
                        activeJobs: 0,
                        isActive: d["isActive"] as? Bool ?? true,
                        avatarName: nil
                    )
                }

                completion(technicians)
            }
    }

    func name(for technicianID: String, completion: @escaping (String?) -> Void) {
        db.collection("users")
            .document(technicianID)
            .getDocument { snap, _ in
                completion(snap?.data()?["name"] as? String)
            }
    }

    // MARK: - Update
    func update(
        technician: Technician,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection("users")
            .document(technician.id)
            .updateData([
                "name": technician.name,
                "specialization": technician.specialization,
                "isActive": technician.isActive,
                "updatedAt": Timestamp(date: Date())
            ]) { error in
                error == nil
                    ? completion(.success(()))
                    : completion(.failure(error!))
            }
    }

    // MARK: - CREATE technician (Auth + Firestore)
    func createTechnician(
        name: String,
        email: String,
        password: String,
        specialization: String,
        extraData: [String: Any],
        completion: @escaping (Result<Technician, Error>) -> Void
    ) {
        let secondaryAuth = Auth.secondary()

        secondaryAuth.createUser(withEmail: email, password: password) { authResult, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(
                    domain: "Auth",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "UID missing"]
                )))
                return
            }

            var data = extraData
            data["name"] = name
            data["email"] = email
            data["role"] = "technician"
            data["specialization"] = specialization
            data["isActive"] = true
            data["updatedAt"] = Timestamp(date: Date())

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(data) { error in

                    // IMPORTANT: clean up secondary auth session
                    try? secondaryAuth.signOut()

                    if let error {
                        completion(.failure(error))
                    } else {
                        completion(.success(
                            Technician(
                                id: uid,
                                name: name,
                                email: email,
                                specialization: specialization,
                                activeJobs: 0,
                                isActive: true,
                                avatarName: nil
                            )
                        ))
                    }
                }
        }
    }
}
