import Foundation

struct LunarCalendarHelper {
    private static let chineseCal: Calendar = {
        var cal = Calendar(identifier: .chinese)
        cal.locale = Locale(identifier: "zh_CN")
        return cal
    }()

    // MARK: - 农历日期文本

    static func lunarDayText(for date: Date) -> String {
        let comps = chineseCal.dateComponents([.month, .day, .isLeapMonth], from: date)
        guard let month = comps.month, let day = comps.day else { return "" }

        if day == 1 {
            let isLeap = comps.isLeapMonth ?? false
            return (isLeap ? "闰" : "") + monthName(month)
        }
        return dayName(day)
    }

    // MARK: - 干支纪年

    static func ganzhiYear(for date: Date) -> String {
        let comps = chineseCal.dateComponents([.year], from: date)
        guard let year = comps.year else { return "" }
        let tianGan = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
        let diZhi = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
        let ganIndex = ((year - 4) % 10 + 10) % 10
        let zhiIndex = ((year - 4) % 12 + 12) % 12
        return tianGan[ganIndex] + diZhi[zhiIndex] + "年"
    }

    // MARK: - 节气

    // 节气查找表：(月, 日) -> 节气名，覆盖2024-2030年
    // 格式：[年: [(月, 日, 节气名)]]
    private static let solarTermTable: [Int: [(Int, Int, String)]] = [
        2024: [
            (1,6,"小寒"),(1,20,"大寒"),
            (2,4,"立春"),(2,19,"雨水"),
            (3,5,"惊蛰"),(3,20,"春分"),
            (4,4,"清明"),(4,19,"谷雨"),
            (5,5,"立夏"),(5,20,"小满"),
            (6,5,"芒种"),(6,21,"夏至"),
            (7,6,"小暑"),(7,22,"大暑"),
            (8,7,"立秋"),(8,22,"处暑"),
            (9,7,"白露"),(9,22,"秋分"),
            (10,8,"寒露"),(10,23,"霜降"),
            (11,7,"立冬"),(11,22,"小雪"),
            (12,7,"大雪"),(12,21,"冬至"),
        ],
        2025: [
            (1,5,"小寒"),(1,20,"大寒"),
            (2,3,"立春"),(2,18,"雨水"),
            (3,5,"惊蛰"),(3,20,"春分"),
            (4,4,"清明"),(4,20,"谷雨"),
            (5,5,"立夏"),(5,21,"小满"),
            (6,5,"芒种"),(6,21,"夏至"),
            (7,7,"小暑"),(7,22,"大暑"),
            (8,7,"立秋"),(8,23,"处暑"),
            (9,7,"白露"),(9,23,"秋分"),
            (10,8,"寒露"),(10,23,"霜降"),
            (11,7,"立冬"),(11,22,"小雪"),
            (12,7,"大雪"),(12,22,"冬至"),
        ],
        2026: [
            (1,5,"小寒"),(1,20,"大寒"),
            (2,4,"立春"),(2,19,"雨水"),
            (3,6,"惊蛰"),(3,21,"春分"),
            (4,5,"清明"),(4,20,"谷雨"),
            (5,5,"立夏"),(5,21,"小满"),
            (6,6,"芒种"),(6,21,"夏至"),
            (7,7,"小暑"),(7,23,"大暑"),
            (8,7,"立秋"),(8,23,"处暑"),
            (9,8,"白露"),(9,23,"秋分"),
            (10,8,"寒露"),(10,23,"霜降"),
            (11,7,"立冬"),(11,22,"小雪"),
            (12,7,"大雪"),(12,22,"冬至"),
        ],
        2027: [
            (1,6,"小寒"),(1,20,"大寒"),
            (2,4,"立春"),(2,19,"雨水"),
            (3,6,"惊蛰"),(3,21,"春分"),
            (4,5,"清明"),(4,20,"谷雨"),
            (5,6,"立夏"),(5,21,"小满"),
            (6,6,"芒种"),(6,22,"夏至"),
            (7,7,"小暑"),(7,23,"大暑"),
            (8,7,"立秋"),(8,23,"处暑"),
            (9,8,"白露"),(9,23,"秋分"),
            (10,8,"寒露"),(10,24,"霜降"),
            (11,7,"立冬"),(11,23,"小雪"),
            (12,7,"大雪"),(12,22,"冬至"),
        ],
        2028: [
            (1,6,"小寒"),(1,21,"大寒"),
            (2,4,"立春"),(2,19,"雨水"),
            (3,5,"惊蛰"),(3,20,"春分"),
            (4,4,"清明"),(4,19,"谷雨"),
            (5,5,"立夏"),(5,20,"小满"),
            (6,5,"芒种"),(6,21,"夏至"),
            (7,6,"小暑"),(7,22,"大暑"),
            (8,7,"立秋"),(8,22,"处暑"),
            (9,7,"白露"),(9,22,"秋分"),
            (10,7,"寒露"),(10,23,"霜降"),
            (11,6,"立冬"),(11,21,"小雪"),
            (12,7,"大雪"),(12,21,"冬至"),
        ],
        2029: [
            (1,5,"小寒"),(1,20,"大寒"),
            (2,3,"立春"),(2,18,"雨水"),
            (3,5,"惊蛰"),(3,20,"春分"),
            (4,4,"清明"),(4,19,"谷雨"),
            (5,5,"立夏"),(5,20,"小满"),
            (6,5,"芒种"),(6,21,"夏至"),
            (7,6,"小暑"),(7,22,"大暑"),
            (8,7,"立秋"),(8,22,"处暑"),
            (9,7,"白露"),(9,22,"秋分"),
            (10,7,"寒露"),(10,23,"霜降"),
            (11,7,"立冬"),(11,22,"小雪"),
            (12,7,"大雪"),(12,22,"冬至"),
        ],
        2030: [
            (1,5,"小寒"),(1,20,"大寒"),
            (2,4,"立春"),(2,19,"雨水"),
            (3,6,"惊蛰"),(3,21,"春分"),
            (4,5,"清明"),(4,20,"谷雨"),
            (5,6,"立夏"),(5,21,"小满"),
            (6,6,"芒种"),(6,21,"夏至"),
            (7,7,"小暑"),(7,23,"大暑"),
            (8,7,"立秋"),(8,23,"处暑"),
            (9,8,"白露"),(9,23,"秋分"),
            (10,8,"寒露"),(10,23,"霜降"),
            (11,7,"立冬"),(11,22,"小雪"),
            (12,7,"大雪"),(12,22,"冬至"),
        ],
    ]

    static func solarTerm(for date: Date) -> String? {
        let greg = Calendar(identifier: .gregorian)
        let comps = greg.dateComponents([.year, .month, .day], from: date)
        guard let year = comps.year, let month = comps.month, let day = comps.day else { return nil }
        guard let terms = solarTermTable[year] else { return nil }
        return terms.first { $0.0 == month && $0.1 == day }?.2
    }

    // MARK: - 传统节日（农历）

    static func holiday(for date: Date) -> String? {
        let comps = chineseCal.dateComponents([.month, .day, .isLeapMonth], from: date)
        guard let month = comps.month, let day = comps.day else { return nil }
        let isLeap = comps.isLeapMonth ?? false
        if isLeap { return nil }

        switch (month, day) {
        case (1, 1):  return "春节"
        case (1, 15): return "元宵"
        case (5, 5):  return "端午"
        case (7, 7):  return "七夕"
        case (7, 15): return "中元"
        case (8, 15): return "中秋"
        case (9, 9):  return "重阳"
        case (12, 8): return "腊八"
        default: break
        }

        // 除夕：腊月最后一天
        if month == 12 {
            let nextDay = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: date)!
            let nextComps = chineseCal.dateComponents([.month], from: nextDay)
            if nextComps.month == 1 {
                return "除夕"
            }
        }

        return nil
    }

    // MARK: - 私有辅助

    private static let monthNames = ["正月","二月","三月","四月","五月","六月",
                                      "七月","八月","九月","十月","冬月","腊月"]

    private static func monthName(_ month: Int) -> String {
        guard month >= 1 && month <= 12 else { return "\(month)月" }
        return monthNames[month - 1]
    }

    private static let dayNames = [
        "初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
        "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
        "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"
    ]

    private static func dayName(_ day: Int) -> String {
        guard day >= 1 && day <= 30 else { return "\(day)" }
        return dayNames[day - 1]
    }
}
