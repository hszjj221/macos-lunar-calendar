import Foundation

struct CalendarMonthBuilder {
    private let calendar: Calendar

    init(calendar: Calendar = AppCalendars.gregorian) {
        self.calendar = calendar
    }

    func days(for displayDate: Date, today: Date = Date()) -> [CalendarDay] {
        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayDate)),
            let daysInMonth = calendar.range(of: .day, in: .month, for: displayDate)?.count
        else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        var result: [CalendarDay] = []

        for offset in (0..<leadingDays).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -(offset + 1), to: startOfMonth) else {
                continue
            }
            result.append(makeDay(date: date, isCurrentMonth: false, today: today))
        }

        for dayOffset in 0..<daysInMonth {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) else {
                continue
            }
            result.append(makeDay(date: date, isCurrentMonth: true, today: today))
        }

        let remaining = 42 - result.count
        if remaining > 0,
           let endOfMonth = calendar.date(byAdding: .day, value: daysInMonth - 1, to: startOfMonth) {
            for dayOffset in 1...remaining {
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: endOfMonth) else {
                    continue
                }
                result.append(makeDay(date: date, isCurrentMonth: false, today: today))
            }
        }

        return Array(result.prefix(42))
    }

    private func makeDay(date: Date, isCurrentMonth: Bool, today: Date) -> CalendarDay {
        CalendarDay(
            date: date,
            gregorianDay: calendar.component(.day, from: date),
            lunarText: LunarCalendarHelper.lunarDayText(for: date),
            solarTerm: LunarCalendarHelper.solarTerm(for: date),
            holiday: LunarCalendarHelper.holiday(for: date) ?? LunarCalendarHelper.gregorianHoliday(for: date),
            isToday: calendar.isDate(date, inSameDayAs: today),
            isCurrentMonth: isCurrentMonth
        )
    }
}
