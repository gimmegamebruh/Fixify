import Foundation

enum RequestStatus: String, Codable, CaseIterable {
    case pending        // student just submitted
    case active         // technician assigned / work started
    case completed      // finished
    case cancelled      // student/admin cancelled

    // 🔥 Admin-only (student flow can ignore)
    case escalated
}
