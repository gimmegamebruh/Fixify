//
//  TechnicianNotificationType.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import Foundation

enum TechnicianNotificationType {
    case assigned
    case scheduled
    case completed
}

struct TechnicianNotification: Identifiable {
    let id: String
    let requestID: String
    let title: String
    let subtitle: String
    let date: Date
    let type: TechnicianNotificationType
}
