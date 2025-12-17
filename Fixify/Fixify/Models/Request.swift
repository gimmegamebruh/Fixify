import Foundation

struct Request: Identifiable, Codable {
    let id: String
    let title: String
    let location: String
    let category: String
    var description: String
    var priority: String
    var status: RequestStatus
    let dateCreated: Date
    let createdBy: String
    let imageName: String?
    var assignedTechnicianID: String?
    let completedDate: Date?
}
