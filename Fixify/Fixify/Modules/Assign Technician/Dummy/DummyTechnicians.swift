import Foundation

struct DummyTechnicians {

    static let data: [Technician] = [

        // ✅ FREE TECHNICIAN (CAN BE ASSIGNED)
        Technician(
            id: "T1",
            name: "Ahmed Hassan",
            email: "ahmed@fixify.com",
            specialization: "Electrical Technician",
            activeJobs: 0,
            isActive: true,
            avatarName: nil,
            metrics: nil
        ),
        
        Technician(
            id: "T4",
            name: "mohammed Hassan",
            email: "ahmed@fixify.com",
            specialization: "Electrical Technician",
            activeJobs: 0,
            isActive: true,
            avatarName: nil,
            metrics: nil
        ),
        
        

        // 🚫 BUSY TECHNICIAN (ASSIGN DISABLED)
        Technician(
            id: "T2",
            name: "Fatima Ali",
            email: "fatima@fixify.com",
            specialization: "HVAC Technician",
            activeJobs: 1,
            isActive: true,
            avatarName: nil,
            metrics: nil
        ),

        // 🚫 BUSY TECHNICIAN (ASSIGN DISABLED)
        Technician(
            id: "T3",
            name: "Mohammed Salman",
            email: "mohammed@fixify.com",
            specialization: "Plumbing Technician",
            activeJobs: 2,
            isActive: true,
            avatarName: nil,
            metrics: nil
        )
        
        
    ]
}
