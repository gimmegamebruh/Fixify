import Foundation

enum RequestStatus: String, Codable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case escalated = "Escalated"
}

