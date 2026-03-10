import SwiftUI

struct MonthGridView: View {
    let displayDate: Date
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                DayCellView(day: day, isSunday: index % 7 == 0)
            }
        }
    }

    private var days: [CalendarDay] {
        var greg = Calendar(identifier: .gregorian)
        greg.locale = Locale(identifier: "zh_CN")
        greg.firstWeekday = 1 // 周日为第一天

        let today = Calendar.current.startOfDay(for: Date())

        // 当月第一天
        let startOfMonth = greg.date(from: greg.dateComponents([.year, .month], from: displayDate))!
        // 当月天数
        let daysInMonth = greg.range(of: .day, in: .month, for: displayDate)!.count
        // 第一天是星期几（1=日, 2=一 ...）
        let firstWeekday = greg.component(.weekday, from: startOfMonth)
        let leadingDays = firstWeekday - 1

        var result: [CalendarDay] = []

        // 前补位
        for offset in (0..<leadingDays).reversed() {
            let date = greg.date(byAdding: .day, value: -(offset + 1), to: startOfMonth)!
            result.append(makeDay(date: date, isCurrentMonth: false, today: today))
        }

        // 当月
        for day in 0..<daysInMonth {
            let date = greg.date(byAdding: .day, value: day, to: startOfMonth)!
            result.append(makeDay(date: date, isCurrentMonth: true, today: today))
        }

        // 后补位（填满 6×7=42 格）
        let remaining = 42 - result.count
        let endOfMonth = greg.date(byAdding: .day, value: daysInMonth - 1, to: startOfMonth)!
        for day in 1...max(1, remaining) {
            let date = greg.date(byAdding: .day, value: day, to: endOfMonth)!
            result.append(makeDay(date: date, isCurrentMonth: false, today: today))
        }

        return Array(result.prefix(42))
    }

    private func makeDay(date: Date, isCurrentMonth: Bool, today: Date) -> CalendarDay {
        let greg = Calendar(identifier: .gregorian)
        let dayNum = greg.component(.day, from: date)
        let isToday = greg.isDate(date, inSameDayAs: today)

        return CalendarDay(
            date: date,
            gregorianDay: dayNum,
            lunarText: LunarCalendarHelper.lunarDayText(for: date),
            solarTerm: LunarCalendarHelper.solarTerm(for: date),
            holiday: LunarCalendarHelper.holiday(for: date) ?? LunarCalendarHelper.gregorianHoliday(for: date),
            isToday: isToday,
            isCurrentMonth: isCurrentMonth
        )
    }
}
