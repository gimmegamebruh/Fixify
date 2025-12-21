import Foundation

struct DummyRequests {

    static let data: [Request] = [

        Request(
            id: UUID().uuidString,
            title: "Projector Issue",
            description: "Projector not turning on during lectures",
            location: "Room 101",
            category: "Electrical",
            priority: .medium,
            status: .completed,
            createdBy: "student1",
            assignedTechnicianID: "T1",
            dateCreated: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
            scheduledTime: nil,
            rating: 4,
            ratingComment: "Fixed quickly",
            imageURL: nil
        ),

        Request(
            id: UUID().uuidString,
            title: "Broken Chair",
            description: "Chair leg is broken and unsafe",
            location: "Class 204",
            category: "Furniture",
            priority: .low,
            status: .pending,
            createdBy: "student2",
            assignedTechnicianID: nil,
            dateCreated: Date(),
            scheduledTime: nil,
            rating: nil,
            ratingComment: nil,
            imageURL: nil
        ),

        Request(
            id: UUID().uuidString,
            title: "AC Maintenance",
            description: "AC not cooling properly",
            location: "Lab 304",
            category: "HVAC",
            priority: .high,
            status: .escalated,
            createdBy: "student3",
            assignedTechnicianID: nil,
            dateCreated: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            scheduledTime: nil,
            rating: nil,
            ratingComment: nil,
            imageURL: nil
        ),

        Request(
            id: UUID().uuidString,
            title: "Water Leakage",
            description: "Water leaking from ceiling",
            location: "Building B",
            category: "Plumbing",
            priority: .urgent,
            status: .escalated,
            createdBy: "student4",
            assignedTechnicianID: nil,
            dateCreated: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            scheduledTime: nil,
            rating: nil,
            ratingComment: nil,
            imageURL: nil
        )
    ]
}
