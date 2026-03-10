import SwiftUI

struct DayCellView: View {
    let day: CalendarDay
    let isSunday: Bool

    var body: some View {
        VStack(spacing: 1) {
            ZStack {
                if day.isToday {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 24, height: 24)
                }
                Text("\(day.gregorianDay)")
                    .font(.system(size: 13, weight: day.isToday ? .bold : .regular))
                    .foregroundColor(gregorianColor)
            }
            Text(day.subText)
                .font(.system(size: 9))
                .foregroundColor(subTextColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .opacity(day.isCurrentMonth ? 1.0 : 0.3)
    }

    private var gregorianColor: Color {
        if day.isToday { return .white }
        if isSunday { return .red }
        return .primary
    }

    private var subTextColor: Color {
        if day.isSpecialDay { return .red }
        return .secondary
    }
}
