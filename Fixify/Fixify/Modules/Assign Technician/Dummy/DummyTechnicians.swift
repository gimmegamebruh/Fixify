//
//  DummyTechnicians.swift
//  Fixify
//

import Foundation

struct DummyTechnicians {

    static let data: [Technician] = [

        Technician(
            id: "T1",
            name: "Ahmed Hassan",
            email: "ahmed@fixify.com",
            specialization: "Electrical Technician",
            activeJobs: 0,
            isActive: true,
            avatarName: nil
        ),

        Technician(
            id: "T2",
            name: "Mohammed Ali",
            email: "mohammed@fixify.com",
            specialization: "HVAC Technician",
            activeJobs: 0,
            isActive: true,
            avatarName: nil
        ),

        Technician(
            id: "T3",
            name: "Fatima Khalid",
            email: "fatima@fixify.com",
            specialization: "Plumbing Technician",
            activeJobs: 0,
            isActive: true,
            avatarName: nil
        )
    ]
}
