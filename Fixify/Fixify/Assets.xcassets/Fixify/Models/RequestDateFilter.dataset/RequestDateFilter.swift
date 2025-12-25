import UIKit

enum RequestDateFilter: CaseIterable {
    case all
    case lastWeek
    case lastMonth

    var title: String {
        switch self {
        case .all: return "All"
        case .lastWeek: return "Last 7 Days"
        case .lastMonth: return "Last 30 Days"
        }
    }

    func includes(_ date: Date) -> Bool {
        let now = Date()

        switch self {
        case .all:
            return true
        case .lastWeek:
            return date >= Calendar.current.date(byAdding: .day, value: -7, to: now)!
        case .lastMonth:
            return date >= Calendar.current.date(byAdding: .month, value: -1, to: now)!
        }
    }
}

