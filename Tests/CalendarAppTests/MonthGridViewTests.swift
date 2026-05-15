import Testing
@testable import CalendarApp

@MainActor
@Test func monthGridViewAcceptsInjectedTodayDate() throws {
    let displayDate = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 15))
    let today = try #require(AppCalendars.gregorianDate(year: 2026, month: 5, day: 16))

    _ = MonthGridView(displayDate: displayDate, today: today)
}
