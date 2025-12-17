import UIKit

struct Request: Identifiable, Codable {

    let id: String
    var title: String
    var description: String
    var location: String
    var category: String
    var priority: RequestPriority
    var status: RequestStatus
    let createdBy: String
    var assignedTo: String?
    let dateCreated: Date
    var scheduledTime: Date?

    // 🔥 NEW
    var rating: Int?
    var ratingComment: String?

    var imageURL: String?
}

