//
//  ChatMessage.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import Foundation
import FirebaseFirestore

struct ChatMessage: Identifiable {

    let id: String
    let text: String
    let senderId: String
    let senderRole: UserRole
    let timestamp: Date

    init?(id: String, data: [String: Any]) {
        guard
            let text = data["text"] as? String,
            let senderId = data["senderId"] as? String,
            let roleString = data["senderRole"] as? String,
            let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
        else { return nil }

        self.id = id
        self.text = text
        self.senderId = senderId
        self.senderRole = UserRole(rawValue: roleString) ?? .student
        self.timestamp = timestamp
    }
}
