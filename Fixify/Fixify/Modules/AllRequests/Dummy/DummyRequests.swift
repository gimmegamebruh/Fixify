//
//  DummyRequests.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import Foundation

struct DummyRequests {
    static let data: [Request] = [
        Request(
            id: UUID().uuidString,
            title: "AC Maintenance",
            location: "Lab 304",
            category: "Electrical",
            description: "AC not cooling",
            priority: "Medium",
            status: .pending,
            dateCreated: Date(),
            createdBy: "student1",
            imageName: "ac1",
            assignedTechnicianID: nil
        ),
        Request(
            id: UUID().uuidString,
            title: "Lighting Issue",
            location: "Hall A",
            category: "Electrical",
            description: "Lights flickering",
            priority: "Low",
            status: .pending,
            dateCreated: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            createdBy: "student2",
            imageName: "ac1",
            assignedTechnicianID: nil
        )
    ]
}
