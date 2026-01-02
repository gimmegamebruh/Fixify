import UIKit

enum RequestStatus: String, Codable, CaseIterable {

    case pending
    case assigned
    case active
    case completed
    case cancelled
    case escalated

    var color: UIColor {
        switch self {
        case .pending:
            return .systemYellow
        case .assigned:
            return .systemTeal
        case .active:
            return .systemBlue
        case .completed:
            return .systemGreen
        case .cancelled:
            return .systemRed
        case .escalated:
            return .systemOrange
        }
    }
}

extension RequestStatus {
    var canAssignTechnician: Bool {
        switch self {
        case .pending, .assigned, .escalated:
            return true
        case .active, .completed, .cancelled:
            return false
        }
    }
}
