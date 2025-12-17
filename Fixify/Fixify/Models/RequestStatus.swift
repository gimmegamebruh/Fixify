import UIKit

enum RequestStatus: String, Codable, CaseIterable {
    case pending, active, completed, cancelled

    var color: UIColor {
        switch self {
        case .pending: return .systemYellow
        case .active: return .systemBlue
        case .completed: return .systemGreen
        case .cancelled: return .systemRed
        }
    }
}

