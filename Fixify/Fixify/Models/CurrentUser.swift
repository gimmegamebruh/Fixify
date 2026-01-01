import Foundation

enum CurrentUser {

    // Session identity
    static var role: UserRole = .student
    static var userID: String?

    // Profile basics
    static var name: String?
    static var email: String?
    static var studentId: String?
    static var profileImageURL: String?

    // Backward compatibility aliases (so old code won’t break)
    static var id: String? {
        get { userID }
        set { userID = newValue }
    }

    static var technicianID: String? {
        get { userID }
        set { userID = newValue }
    }
}

