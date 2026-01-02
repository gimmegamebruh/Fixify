//
//  Technician.swift
//  Fixify
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
}
