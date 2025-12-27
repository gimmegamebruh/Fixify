import Foundation
import FirebaseFirestore

struct Product: Codable, Identifiable {
    @DocumentID var documentId: String?
    var id: String
    var name: String
    var cost: Double
    var quantity: Int
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case id
        case name
        case cost
        case quantity
        case createdAt
        case updatedAt
    }
    
    init(id: String, name: String, cost: Double, quantity: Int, documentId: String? = nil) {
        self.id = id
        self.name = name
        self.cost = cost
        self.quantity = quantity
        self.documentId = documentId
    }
    
    // Convert to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "cost": cost,
            "quantity": quantity
        ]
        
        if let createdAt = createdAt {
            dict["createdAt"] = createdAt
        }
        
        dict["updatedAt"] = FieldValue.serverTimestamp()
        
        return dict
    }
}
