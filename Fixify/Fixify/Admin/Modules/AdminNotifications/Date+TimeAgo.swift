import Foundation

extension Date {

    func timeAgoDisplay() -> String {

        let seconds = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 3600
        let day = 86400

        if seconds < minute {
            return "Just now"
        }

        if seconds < hour {
            return "\(seconds / minute) min ago"
        }

        if seconds < day {
            return "\(seconds / hour) hrs ago"
        }

        return "\(seconds / day) days ago"
    }
}
