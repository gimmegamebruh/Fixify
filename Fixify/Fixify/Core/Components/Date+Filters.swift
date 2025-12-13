import Foundation

extension Date {
    var isWithinLastWeek: Bool {
        self >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }
    var isWithinLastMonth: Bool {
        self >= Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    }
    var isWithinLastYear: Bool {
        self >= Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    }
}
