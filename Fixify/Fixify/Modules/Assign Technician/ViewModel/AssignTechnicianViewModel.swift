import Foundation

class AssignTechnicianViewModel {

    private let requestID: String
    private(set) var technicians: [Technician] = []
    private(set) var assignedTechnicianID: String?

    init(requestID: String) {
        self.requestID = requestID
    }

    func loadDummyData() {
        technicians = DummyTechnicians.data
            .sorted { $0.activeJobs < $1.activeJobs }
    }

    func assignTechnician(_ technicianID: String) {
        assignedTechnicianID = technicianID
        print("Assigned technician \(technicianID) to request \(requestID)")
    }

    func isAssigned(_ technicianID: String) -> Bool {
        assignedTechnicianID == technicianID
    }
}
