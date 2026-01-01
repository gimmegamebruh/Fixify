import Foundation

struct Request: Identifiable, Codable {

    let id: String

    // Core info (student creates these)
    var title: String
    var description: String
    var location: String
    var category: String

    // Status & priority (admin controls)
    var priority: RequestPriority
    var status: RequestStatus

    // Ownership
    let createdBy: String
    var assignedTechnicianID: String?
    var assignmentSource: AssignmentSource?
    var assignedByUserID: String?

    // Timing
    let dateCreated: Date
    var scheduledTime: Date?

    // Feedback (optional, student side)
    var rating: Int?
    var ratingComment: String?

    // Media (Firebase-friendly)
    var imageURL: String?

    var effectiveAssignmentSource: AssignmentSource? {
        if let assignmentSource { return assignmentSource }
        if assignedTechnicianID != nil { return .admin }
        return nil
    }

    var isAssigned: Bool {
        assignedTechnicianID != nil
    }
}
