import Foundation

struct Request: Codable, Identifiable {
    let id: String
    let title: String
    let location: String
    let category: String
    let description: String
    let priority: String
    var status: RequestStatus
    let dateCreated: Date
    let createdBy: String
    let imageName: String?
    var assignedTechnicianID: String?
}
