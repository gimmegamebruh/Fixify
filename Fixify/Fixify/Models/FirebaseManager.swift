import Foundation
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Product Methods
    
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let products = documents.compactMap { doc -> Product? in
                try? doc.data(as: Product.self)
            }
            
            completion(.success(products))
        }
    }
    
    func fetchProduct(byId productId: String, completion: @escaping (Result<Product, Error>) -> Void) {
        db.collection("products")
            .whereField("id", isEqualTo: productId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first,
                      let product = try? document.data(as: Product.self) else {
                    completion(.failure(NSError(domain: "FirebaseManager",
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                completion(.success(product))
            }
    }
    
    func updateProductQuantity(id productId: String, newQuantity: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // First find the document with matching id field
        db.collection("products")
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "FirebaseManager",
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                // Update the document
                self?.db.collection("products").document(document.documentID).updateData([
                    "quantity": newQuantity,
                    "updatedAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    func addProduct(_ product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        let productData = product.toDictionary()
        
        db.collection("products").addDocument(data: productData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteProduct(id productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("products")
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "FirebaseManager",
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                self?.db.collection("products").document(document.documentID).delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
}
