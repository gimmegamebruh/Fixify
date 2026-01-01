import Foundation

enum AssignmentSource: String, Codable {
    case admin
    case technician

    var displayName: String {
        switch self {
        case .admin:
            return "Admin"
        case .technician:
            return "You"
        }
    }
}
