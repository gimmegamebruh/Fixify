//
//  TechnicianMetrics.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import Foundation

struct TechnicianMetrics: Codable {
    var totalJobsCompleted: Int
    var pendingJobs: Int
    var averageCompletionTime: Double
    var customerRating: Double
    var totalReviews: Int
}
