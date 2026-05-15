import Foundation

enum AppCalendars {
    static var gregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "zh_CN")
        calendar.firstWeekday = 1
        return calendar
    }

    static func gregorianDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.calendar = gregorian
        components.year = year
        components.month = month
        components.day = day
        return components.date
    }
}
