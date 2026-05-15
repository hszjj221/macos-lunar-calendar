#!/bin/sh
set -eu

tmpdir="$(mktemp -d /private/tmp/calendar-model-tests.XXXXXX)"
trap 'rm -rf "$tmpdir"' EXIT

cat > "$tmpdir/main.swift" <<'SWIFT'
import Foundation

func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        fputs("FAIL: \(message)\n", stderr)
        exit(1)
    }
}

func requireDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
    guard let date = AppCalendars.gregorianDate(year: year, month: month, day: day) else {
        fputs("FAIL: invalid date \(year)-\(month)-\(day)\n", stderr)
        exit(1)
    }
    return date
}

check(LunarCalendarHelper.ganzhiYear(for: requireDate(2024, 2, 10)) == "甲辰年", "2024 Spring Festival ganzhi")
check(LunarCalendarHelper.ganzhiYear(for: requireDate(2026, 2, 17)) == "丙午年", "2026 Spring Festival ganzhi")

let eve = requireDate(2026, 2, 16)
check(LunarCalendarHelper.ganzhiYear(for: eve) == "乙巳年", "2026 eve ganzhi")
check(LunarCalendarHelper.holiday(for: eve) == "除夕", "2026 eve holiday")

check(LunarCalendarHelper.solarTerm(for: requireDate(2026, 3, 6)) == "惊蛰", "2026 known solar term")
check(LunarCalendarHelper.solarTerm(for: requireDate(2031, 3, 6)) == nil, "2031 solar term boundary")
check(LunarCalendarHelper.gregorianHoliday(for: requireDate(2026, 1, 1)) == "元旦", "gregorian holiday")

let march = CalendarMonthBuilder().days(for: requireDate(2026, 3, 15), today: requireDate(2026, 3, 6))
check(march.count == 42, "March grid count")
check(march[0].gregorianDay == 1 && march[0].isCurrentMonth, "March first cell")
check(march[41].gregorianDay == 11 && !march[41].isCurrentMonth, "March trailing cell")

let may = CalendarMonthBuilder().days(for: requireDate(2026, 5, 15), today: requireDate(2026, 5, 15))
check(may.count == 42, "May grid count")
check(may[0].gregorianDay == 26 && !may[0].isCurrentMonth, "May leading cell")
check(may[5].gregorianDay == 1 && may[5].isCurrentMonth, "May first current-month cell")

let todayCells = may.filter { $0.isToday }
check(todayCells.count == 1, "Today cell count")
check(todayCells[0].gregorianDay == 15 && todayCells[0].isCurrentMonth, "Today cell identity")

let nextDay = CalendarMonthBuilder().days(for: requireDate(2026, 5, 15), today: requireDate(2026, 5, 16))
let nextDayTodayCells = nextDay.filter { $0.isToday }
check(nextDayTodayCells.count == 1, "Next-day today cell count")
check(nextDayTodayCells[0].gregorianDay == 16 && nextDayTodayCells[0].isCurrentMonth, "Next-day today cell identity")

print("model assertions passed")
SWIFT

swiftc \
    Sources/CalendarApp/Models/AppCalendars.swift \
    Sources/CalendarApp/Models/CalendarDay.swift \
    Sources/CalendarApp/Models/LunarCalendarHelper.swift \
    Sources/CalendarApp/Models/CalendarMonthBuilder.swift \
    "$tmpdir/main.swift" \
    -o "$tmpdir/calendar-model-tests"

"$tmpdir/calendar-model-tests"
