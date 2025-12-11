import Foundation

extension Date {
    
    var isWithinLastWeek: Bool {
        let cal = Calendar.current
        let weekAgo = cal.date(byAdding: .day, value: -7, to: Date())!
        return self >= weekAgo
    }
    
    var isWithinLastMonth: Bool {
        let cal = Calendar.current
        let monthAgo = cal.date(byAdding: .month, value: -1, to: Date())!
        return self >= monthAgo
    }
    
    var isWithinLastYear: Bool {
        let cal = Calendar.current
        let yearAgo = cal.date(byAdding: .year, value: -1, to: Date())!
        return self >= yearAgo
    }
}
