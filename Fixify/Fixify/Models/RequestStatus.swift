import UIKit

enum RequestStatus: String, Codable, CaseIterable {

    case pending        // student just submitted
    case assigned       // assigned to a technician but not started
    case active         // technician working on it
    case completed      // finished
    case cancelled      // student/admin cancelled

    // 🔥 Admin-only
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
