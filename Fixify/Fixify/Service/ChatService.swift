//
//  ChatService.swift
//  Fixify
//

import FirebaseFirestore

final class ChatService {

    static let shared = ChatService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Listen to chat messages
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

    // MARK: - Send message (🔥 FIX INCLUDED)
    func send(requestID: String, text: String) {
        // 1️⃣ CHANGE THIS: Use the resolved ID instead of the static property
        guard let senderId = CurrentUser.resolvedUserID() else {
            print("DEBUG: Send failed because senderId is nil")
            return
        }

        let data: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "senderRole": CurrentUser.role.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]

        let requestRef = db.collection("requests").document(requestID)

        // 2️⃣ Send chat message
        requestRef
            .collection("chat")
            .addDocument(data: data) { error in
                if let error = error {
                    print("DEBUG: Firestore Error: \(error.localizedDescription)")
                }
            }

        // 3️⃣ Activate request
        requestRef.updateData([
            "status": RequestStatus.active.rawValue
        ])
    }
}
