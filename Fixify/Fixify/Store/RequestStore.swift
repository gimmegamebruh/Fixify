import Foundation

final class RequestStore {

    static let shared = RequestStore()

    private(set) var requests: [Request] = []

    private let currentStudentID = "student123"

    private init() {
        seedDummyData()
    }

    private func seedDummyData() {
        let now = Date()

        requests = [
            Request(
                id: UUID(),
                title: "AC Leak in Lab 3",
                location: "Building C - Lab 3",
                priority: "High",
                category: "AC Issue",
                description: "AC is dripping water near the whiteboard.",
                status: .pending,
                dateCreated: now,
                createdBy: currentStudentID
            ),
            Request(
                id: UUID(),
                title: "Projector Not Working",
                location: "Building A - Room 105",
                priority: "Medium",
                category: "Electrical",
                description: "Projector doesn't turn on.",
                status: .active,
                dateCreated: now.addingTimeInterval(-3600 * 24),
                createdBy: currentStudentID
            ),
            Request(
                id: UUID(),
                title: "Broken Chair",
                location: "Building D - Class 204",
                priority: "Low",
                category: "Furniture",
                description: "Student chair leg is broken.",
                status: .completed,
                dateCreated: now.addingTimeInterval(-3600 * 24 * 5),
                createdBy: currentStudentID
            )
        ]
    }

    // MARK: - Accessors

    var count: Int {
        return requests.count
    }

    func request(at index: Int) -> Request {
        return requests[index]
    }

    // MARK: - Mutations

    func add(_ request: Request) {
        requests.insert(request, at: 0)
    }

    func update(at index: Int, with request: Request) {
        guard requests.indices.contains(index) else { return }
        requests[index] = request
    }

    func cancel(at index: Int) {
        guard requests.indices.contains(index) else { return }
        if requests[index].status == .pending {
            requests[index].status = .cancelled
        }
    }
}
