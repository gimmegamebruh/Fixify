//
//  Request.swift
//  Fixify
//
//  Created by BP-36-201-06 on 11/12/2025.
//


import Foundation

struct Request {
    let id: String
    let title: String
    let location: String
    let category: String
    let description: String
    let priority: String
    let status: RequestStatus
    let dateCreated: Date
    let createdBy: String
    let imageName: String?
}
