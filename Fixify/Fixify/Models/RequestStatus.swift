import UIKit

enum RequestStatus: String, Codable, CaseIterable {
    case pending
    case active
    case completed
    case cancelled

    var displayName: String {
        switch self {
        case .pending:   return "Pending"
        case .active:    return "Active"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }

    var color: UIColor {
        switch self {
        case .pending:   return .systemYellow
        case .active:    return .systemBlue
        case .completed: return .systemGreen
        case .cancelled: return .systemRed
        }
    }
}

