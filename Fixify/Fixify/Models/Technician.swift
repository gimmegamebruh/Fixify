//
//  Technician.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import Foundation

struct Technician: Codable, Identifiable {

    let id: String
    var name: String
    var email: String
    var specialization: String
    var activeJobs: Int
    var isActive: Bool
    var avatarName: String?
    var metrics: TechnicianMetrics?
}
