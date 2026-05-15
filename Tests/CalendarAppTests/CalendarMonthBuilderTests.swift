import Testing
@testable import CalendarApp

@Test func buildsFixedSixWeekGridForMonthStartingOnSunday() throws {
    let displayDate = try #require(AppCalendars.gregorianDate(year: 2026, month: 3, day: 15))
    let today = try #require(AppCalendars.gregorianDate(year: 2026, month: 3, day: 6))
    let days = CalendarMonthBuilder().days(for: displayDate, today: today)

    #expect(days.count == 42)
    #expect(days[0].gregorianDay == 1)
    #expect(days[0].isCurrentMonth)
    #expect(days[41].gregorianDay == 11)
    #expect(!days[41].isCurrentMonth)
}

@Test func buildsLeadingDaysForMonthStartingMidWeek() throws {
    let displayDate = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 15))
    let today = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 15))
    let days = CalendarMonthBuilder().days(for: displayDate, today: today)

    #expect(days.count == 42)
    #expect(days[0].gregorianDay == 26)
    #expect(!days[0].isCurrentMonth)
    #expect(days[5].gregorianDay == 1)
    #expect(days[5].isCurrentMonth)
}

@Test func injectedTodayMarksExactlyOneDay() throws {
    let displayDate = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 15))
    let today = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 15))
    let days = CalendarMonthBuilder().days(for: displayDate, today: today)
    let todayCells = days.filter { $0.isToday }

    #expect(todayCells.count == 1)
    #expect(todayCells[0].gregorianDay == 15)
    #expect(todayCells[0].isCurrentMonth)
}
