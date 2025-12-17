import Foundation

protocol TechnicianServicing {
    func fetchAll(completion: @escaping ([Technician]) -> Void)
}
