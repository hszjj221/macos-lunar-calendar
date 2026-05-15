import Foundation

struct CalendarDay: Identifiable {
    let date: Date
    let gregorianDay: Int
    let lunarText: String
    let solarTerm: String?
    let holiday: String?
    let isToday: Bool
    let isCurrentMonth: Bool

    var id: Date { date }

    // 优先显示：节日 > 节气 > 农历
    var subText: String {
        if let h = holiday { return h }
        if let s = solarTerm { return s }
        return lunarText
    }

    var isSpecialDay: Bool {
        holiday != nil || solarTerm != nil
    }
}
