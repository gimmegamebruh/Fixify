import UIKit


struct Request {
    var id: UUID
    var title: String
    var location: String
    var priority: String
    var category: String
    var description: String
    var status: RequestStatus
    var dateCreated: Date
    var createdBy: String
    var photo: UIImage?

}
