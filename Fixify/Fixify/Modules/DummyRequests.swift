import Foundation

struct DummyRequests {
    static let data: [Request] = [

        Request(
            id: UUID().uuidString,
            title: "AC Maintenance",
            location: "Lab 304",
            category: "Electrical",
            description: "AC not cooling properly.",
            priority: "Medium",
            status: .pending,
            dateCreated: Date(),
            createdBy: "student123",
            imageName: "ac1"
        ),

        Request(
            id: UUID().uuidString,
            title: "AC Maintenance",
            location: "Lab 304",
            category: "Electrical",
            description: "Noise issue.",
            priority: "Medium",
            status: .pending,
            dateCreated: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            createdBy: "student456",
            imageName: nil      // ❗ no image → auto hide image
        )
    ]
}
