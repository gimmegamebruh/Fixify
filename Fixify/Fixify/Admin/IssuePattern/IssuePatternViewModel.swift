//
//  IssuePatternViewModel.swift
//  Fixify
//
//  Created by BP-36-212-12 on 29/12/2025.
//


import Foundation

final class IssuePatternViewModel {

    private let store = RequestStore.shared

    /// Returns sorted issue counts by location (descending)
    func issuesByLocation() -> [(key: String, count: Int)] {
        let grouped = Dictionary(grouping: store.requests) { $0.location }

        return grouped
            .map { (key: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }

    /// Returns sorted issue counts by category (descending)
    func issuesByCategory() -> [(key: String, count: Int)] {
        let grouped = Dictionary(grouping: store.requests) { $0.category }

        return grouped
            .map { (key: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
}
