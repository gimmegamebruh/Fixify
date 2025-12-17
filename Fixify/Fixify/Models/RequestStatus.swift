import Foundation

enum RequestStatus: String, Codable {
    case pending = "Pending"
    case assigned = "Assigned"
    case inProgress = "In Progress"
    case completed = "Completed"
    case escalated = "Escalated"
}
