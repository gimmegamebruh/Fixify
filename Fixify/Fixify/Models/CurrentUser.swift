import Foundation
import FirebaseAuth

enum CurrentUser {

    static var role: UserRole = .student

    // 🔥 Identity
    static var id: String?
    static var name: String?
    static var email: String?
    static var studentId: String?
    static var technicianID: String?

    // Profile
    static var contactNumber: String?
    static var address: String?
    static var emergencyContact: String?
    static var profileImageURL: String?

    // MARK: - Hydration (🔥 REQUIRED)
    static func hydrate(
        role: UserRole,
        technicianID: String? = nil
    ) {
        guard let user = Auth.auth().currentUser else {
            fatalError("❌ Firebase user missing during CurrentUser.hydrate")
        }

        self.id = user.uid             
        self.email = user.email
        self.role = role
        self.technicianID = technicianID

        debugPrintSession()
    }

    // MARK: - Safety
    static func requireID() -> String {
        guard let id else {
            fatalError("❌ CurrentUser.id is nil — login not completed")
        }
        return id
    }

    // MARK: - Clear
    static func clear() {
        id = nil
        email = nil
        name = nil
        studentId = nil
        role = .student
        profileImageURL = nil
        contactNumber = nil
        address = nil
        emergencyContact = nil
        technicianID = nil
    }

    // MARK: - Debug
    private static func debugPrintSession() {
        print("""
        ✅ CurrentUser hydrated
        id: \(id ?? "nil")
        email: \(email ?? "nil")
        role: \(role)
        technicianID: \(technicianID ?? "nil")
        """)
    }
}
