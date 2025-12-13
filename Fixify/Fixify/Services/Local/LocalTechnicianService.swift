final class LocalTechnicianService: TechnicianServicing {
    func fetchAll(completion: @escaping ([Technician]) -> Void) {
        completion(DummyTechnicians.data)
    }
}
