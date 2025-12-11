//
//  RequestStatus.swift
//  Fixify
//
//  Created by BP-36-201-06 on 11/12/2025.
//


import Foundation

enum RequestStatus: String, Codable {
    case pending = "Pending"
    case assigned = "Assigned"
    case inProgress = "In Progress"
    case completed = "Completed"
    case escalated = "Escalated"
}
