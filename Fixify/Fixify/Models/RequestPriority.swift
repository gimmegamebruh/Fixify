//
//  RequestPriority.swift
//  Fixify
//
//  Created by BP-36-213-15 on 21/12/2025.
//


import UIKit

enum RequestPriority: String, Codable, CaseIterable {
    case low
    case medium
    case high
    case urgent

    var color: UIColor {
        switch self {
        case .low:
            return .systemGreen
        case .medium:
            return .systemBlue
        case .high:
            return .systemOrange
        case .urgent:
            return .systemRed
        }
    }
}
