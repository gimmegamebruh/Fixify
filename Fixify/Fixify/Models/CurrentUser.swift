import Foundation

enum CurrentUser {
    static var role: UserRole = .student
    static var id: String?
    static var name: String?
    static var email: String?
    static var contactNumber: String?
    static var address: String?
    static var emergencyContact: String?
    static var studentId: String?
    static var technicianID: String?
    static var profileImageURL: String?
    
    
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
}

