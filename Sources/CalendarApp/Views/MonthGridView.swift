import SwiftUI

struct MonthGridView: View {
    let displayDate: Date
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let builder = CalendarMonthBuilder()

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                DayCellView(day: day, isSunday: index % 7 == 0)
            }
        }
    }

    private var days: [CalendarDay] {
        builder.days(for: displayDate)
    }
}
