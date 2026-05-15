import SwiftUI

struct MonthGridView: View {
    let displayDate: Date
    let today: Date

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let builder = CalendarMonthBuilder()

    init(displayDate: Date, today: Date = Date()) {
        self.displayDate = displayDate
        self.today = today
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                DayCellView(day: day, isSunday: index % 7 == 0)
            }
        }
    }

    private var days: [CalendarDay] {
        builder.days(for: displayDate, today: today)
    }
}
