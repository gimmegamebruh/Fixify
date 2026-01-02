import Foundation
import FirebaseFirestore

final class ProductService {
    static let shared = ProductService()
    private let db = Firestore.firestore()
    private let productsCollection = "products"
    
    private init() {}
    
    // MARK: - Create
    
    /// Add a new product to Firestore
    func addProduct(
        id: String,
        name: String,
        cost: Double,
        quantity: Int,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let productRef = db.collection(productsCollection).document(id)

        productRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if document?.exists == true {
                completion(.failure(NSError(
                    domain: "",
                    code: 409,
                    userInfo: [NSLocalizedDescriptionKey: "Product ID already exists"]
                )))
                return
            }

            // ✅ ID is unique
            let productData: [String: Any] = [
                "id": id,
                "name": name,
                "cost": cost,
                "quantity": quantity,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
            ]

            productRef.setData(productData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success("Product added successfully"))
                }
            }
        }
    }

    
    // MARK: - Read
    
    /// Fetch all products
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        db.collection(productsCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let products = documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            }
            
            completion(.success(products))
        }
    }
    
    /// Fetch product by product ID (the id field, not document ID)
    func fetchProduct(byProductId productId: String, completion: @escaping (Result<Product?, Error>) -> Void) {
        db.collection(productsCollection)
            .whereField("id", isEqualTo: productId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.success(nil))
                    return
                }
                
                do {
                    let product = try document.data(as: Product.self)
                    completion(.success(product))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    /// Search products by name
    func searchProducts(query: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        fetchAllProducts { result in
            switch result {
            case .success(let products):
                let filtered = products.filter { product in
                    product.name.lowercased().contains(query.lowercased()) ||
                    product.id.lowercased().contains(query.lowercased())
                }
                completion(.success(filtered))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update
    
    /// Update product quantity
    func updateQuantity(productId: String, newQuantity: Int, completion: @escaping (Result<String, Error>) -> Void) {
        // First find the document with this product ID
        db.collection(productsCollection)
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                // Update the document
                self?.db.collection(self?.productsCollection ?? "products")
                    .document(document.documentID)
                    .updateData([
                        "quantity": newQuantity,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success("Quantity updated successfully"))
                        }
                    }
            }
    }
    
    /// Update product cost/price
    func updateCost(productId: String, newCost: Double, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection(productsCollection)
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                self?.db.collection(self?.productsCollection ?? "products")
                    .document(document.documentID)
                    .updateData([
                        "cost": newCost,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success("Cost updated successfully"))
                        }
                    }
            }
    }
    
    /// Update entire product
    func updateProduct(productId: String, name: String, cost: Double, quantity: Int, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection(productsCollection)
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                self?.db.collection(self?.productsCollection ?? "products")
                    .document(document.documentID)
                    .updateData([
                        "name": name,
                        "cost": cost,
                        "quantity": quantity,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success("Product updated successfully"))
                        }
                    }
            }
    }
    
    // MARK: - Delete
    
    /// Delete a product by product ID
    func deleteProduct(productId: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection(productsCollection)
            .whereField("id", isEqualTo: productId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                    return
                }
                
                self?.db.collection(self?.productsCollection ?? "products")
                    .document(document.documentID)
                    .delete { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success("Product deleted successfully"))
                        }
                    }
            }
    }
    
    // MARK: - Statistics
    
    /// Get total number of products
    func getTotalProductCount(completion: @escaping (Result<Int, Error>) -> Void) {
        db.collection(productsCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let count = snapshot?.documents.count ?? 0
            completion(.success(count))
        }
    }
    
    /// Get total inventory value
    func getTotalInventoryValue(completion: @escaping (Result<Double, Error>) -> Void) {
        fetchAllProducts { result in
            switch result {
            case .success(let products):
                let totalValue = products.reduce(0.0) { sum, product in
                    sum + (product.cost * Double(product.quantity))
                }
                completion(.success(totalValue))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Get low stock products (quantity < threshold)
    func getLowStockProducts(threshold: Int = 5, completion: @escaping (Result<[Product], Error>) -> Void) {
        fetchAllProducts { result in
            switch result {
            case .success(let products):
                let lowStock = products.filter { $0.quantity < threshold }
                completion(.success(lowStock))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
