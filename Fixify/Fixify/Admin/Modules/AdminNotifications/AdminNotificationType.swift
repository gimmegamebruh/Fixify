//
//  AdminNotificationType.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import UIKit

enum AdminNotificationType {
    case newRequest
    case escalated
    case completed

    var icon: UIImage? {
        switch self {
        case .newRequest:
            return UIImage(systemName: "doc.text.fill")
        case .escalated:
            return UIImage(systemName: "exclamationmark.triangle.fill")
        case .completed:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }

    var color: UIColor {
        switch self {
        case .newRequest:
            return .systemBlue
        case .escalated:
            return .systemRed
        case .completed:
            return .systemGreen
        }
    }

    var title: String {
        switch self {
        case .newRequest:
            return "New request submitted"
        case .escalated:
            return "Request escalated"
        case .completed:
            return "Request completed"
        }
    }
}

struct AdminNotification {
    let id: String
    let subtitle: String
    let date: Date
    let type: AdminNotificationType
}
