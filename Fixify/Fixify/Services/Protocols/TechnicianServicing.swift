//
//  TechnicianServicing.swift
//  Fixify
//
//  Created by BP-36-201-02 on 13/12/2025.
//


import Foundation

protocol TechnicianServicing {
    func fetchAll(completion: @escaping ([Technician]) -> Void)
}
