//
//  ChatService.swift
//  Fixify
//
//  Created by BP-36-213-15 on 25/12/2025.
//


import FirebaseFirestore

final class ChatService {

    static let shared = ChatService()
    private let db = Firestore.firestore()

    private init() {}

    func listen(
        requestID: String,
        completion: @escaping ([ChatMessage]) -> Void
    ) {
        db.collection("requests")
            .document(requestID)
            .collection("chat")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, _ in

                let messages = snapshot?.documents.compactMap {
                    ChatMessage(id: $0.documentID, data: $0.data())
                } ?? []

                completion(messages)
            }
    }

    func send(requestID: String, text: String) {
        guard let senderId = CurrentUser.id else { return }

        let data: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "senderRole": CurrentUser.role.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("requests")
            .document(requestID)
            .collection("chat")
            .addDocument(data: data)
    }
}
