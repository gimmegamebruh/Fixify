import Foundation

struct DummyTechnicians {
    static let data: [Technician] = [
        Technician(
            id: "T1",
            name: "Ahmed Hassan",
            email: "ahmed@fixify.com",
            specialization: "Electrical Technician",
            activeJobs: 2,
            isActive: true,
            avatarName: nil,
            metrics: nil
        ),
        Technician(
            id: "T2",
            name: "Fatima Ali",
            email: "fatima@fixify.com",
            specialization: "HVAC Technician",
            activeJobs: 1,
            isActive: true,
            avatarName: nil,
            metrics: nil
        )
    ]
}
