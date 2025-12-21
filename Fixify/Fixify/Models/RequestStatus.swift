import UIKit

enum RequestStatus: String, Codable, CaseIterable {

    case pending        // student just submitted
    case active         // technician assigned / work started
    case completed      // finished
    case cancelled      // student/admin cancelled

    // 🔥 Admin-only
    case escalated

    var color: UIColor {
        switch self {
        case .pending:
            return .systemYellow
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
