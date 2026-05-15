import Testing
@testable import CalendarApp

@Test func ganzhiYearUsesChineseCycleYearForSpringFestival2024() throws {
    let date = try #require(AppCalendars.gregorianDate(year: 2024, month: 2, day: 10))

    #expect(LunarCalendarHelper.ganzhiYear(for: date) == "甲辰年")
}

@Test func ganzhiYearUsesChineseCycleYearForSpringFestival2026() throws {
    let date = try #require(AppCalendars.gregorianDate(year: 2026, month: 2, day: 17))

    #expect(LunarCalendarHelper.ganzhiYear(for: date) == "丙午年")
}

@Test func dayBeforeSpringFestival2026BelongsToPreviousGanzhiYearAndIsNewYearsEve() throws {
    let dayBeforeSpringFestival = try #require(AppCalendars.gregorianDate(year: 2026, month: 2, day: 16))

    #expect(LunarCalendarHelper.ganzhiYear(for: dayBeforeSpringFestival) == "乙巳年")
    #expect(LunarCalendarHelper.holiday(for: dayBeforeSpringFestival) == "除夕")
}

@Test func solarTermTableContainsKnown2026Term() throws {
    let date = try #require(AppCalendars.gregorianDate(year: 2026, month: 3, day: 6))

    #expect(LunarCalendarHelper.solarTerm(for: date) == "惊蛰")
}

@Test func solarTermOutsideSupportedRangeReturnsNil() throws {
    let date = try #require(AppCalendars.gregorianDate(year: 2031, month: 3, day: 6))

    #expect(LunarCalendarHelper.solarTerm(for: date) == nil)
}

@Test func gregorianHoliday() throws {
    let date = try #require(AppCalendars.gregorianDate(year: 2026, month: 1, day: 1))

    #expect(LunarCalendarHelper.gregorianHoliday(for: date) == "元旦")
}
