import Foundation

protocol RequestServicing {
    func fetchAll(completion: @escaping ([Request]) -> Void)

    func assignTechnician(
        requestID: String,
        technicianID: String,
        completion: @escaping (Bool) -> Void
    )

    func updateRequest(_ request: Request)
}
