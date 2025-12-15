import Foundation

struct DummyRequests {

    static let data: [Request] = [

        // COMPLETED
        Request(
            id: UUID().uuidString,
            title: "Projector Issue",
            location: "Room 101",
            category: "Electrical",
            description: "Projector not working",
            priority: "Medium",
            status: .completed,
            dateCreated: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
            createdBy: "student1",
            imageName: nil,
            assignedTechnicianID: "T1",
            completedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
        ),

        // PENDING
        Request(
            id: UUID().uuidString,
            title: "Broken Chair",
            location: "Class 204",
            category: "Furniture",
            description: "Chair broken",
            priority: "Low",
            status: .pending,
            dateCreated: Date(),
            createdBy: "student2",
            imageName: nil,
            assignedTechnicianID: nil,
            completedDate: nil
        ),

        // ESCALATED - OVERDUE
        Request(
            id: UUID().uuidString,
            title: "AC Maintenance",
            location: "Lab 304",
            category: "HVAC",
            description: "AC not cooling",
            priority: "High",
            status: .escalated,
            dateCreated: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            createdBy: "student3",
            imageName: "ac1",
            assignedTechnicianID: nil,
            completedDate: nil
        ),

        // ESCALATED - URGENT
        Request(
            id: UUID().uuidString,
            title: "Water Leakage",
            location: "Building B",
            category: "Plumbing",
            description: "Pipe leakage",
            priority: "High",
            status: .escalated,
            dateCreated: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            createdBy: "student4",
            imageName: nil,
            assignedTechnicianID: nil,
            completedDate: nil
        )
    ]
}
