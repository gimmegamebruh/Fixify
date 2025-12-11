//
//  AllRequestsViewModel.swift
//  Fixify
//
//  Created by BP-36-201-06 on 11/12/2025.
//


import Foundation

class AllRequestsViewModel {
    
    private(set) var allRequests: [Request] = []
    
    func loadDummyData() {
        allRequests = DummyRequests.data
    }
    
    func filtered(_ filter: RequestFilter) -> [Request] {
        switch filter {
        case .lastWeek:
            return allRequests.filter { $0.dateCreated.isWithinLastWeek }
        case .lastMonth:
            return allRequests.filter { $0.dateCreated.isWithinLastMonth }
        case .lastYear:
            return allRequests.filter { $0.dateCreated.isWithinLastYear }
        case .allTime:
            return allRequests
        }
    }
}
