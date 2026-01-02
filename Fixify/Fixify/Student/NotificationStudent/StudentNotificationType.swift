//
//  StudentNotificationType.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

enum StudentNotificationType {
    case assigned
    case scheduled
    case completed

    var icon: UIImage? {
        switch self {
        case .assigned:
            return UIImage(systemName: "person.crop.circle.badge.checkmark")
        case .scheduled:
            return UIImage(systemName: "calendar.badge.clock")
        case .completed:
            return UIImage(systemName: "checkmark.seal.fill")
        }
    }

    var color: UIColor {
        switch self {
        case .assigned:
            return .systemBlue
        case .scheduled:
            return .systemOrange
        case .completed:
            return .systemGreen
        }
    }

    var title: String {
        switch self {
        case .assigned:
            return "Technician Assigned"
        case .scheduled:
            return "Visit Scheduled"
        case .completed:
            return "Request Completed"
        }
    }
}

struct StudentNotification {
    let id: String
    let requestID: String
    let subtitle: String
    let date: Date
    let type: StudentNotificationType
}
