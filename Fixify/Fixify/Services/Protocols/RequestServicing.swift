//
//  RequestServicing.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import Foundation

protocol RequestServicing {
    func fetchAll(completion: @escaping ([Request]) -> Void)
    func assignTechnician(
        requestID: String,
        technicianID: String,
        completion: @escaping (Bool) -> Void
    )
}
