import SwiftUI

struct CalendarPopoverView: View {
    @State private var displayDate: Date = Date()

    private let weekdayLabels = ["日","一","二","三","四","五","六"]

    var body: some View {
        VStack(spacing: 8) {
            // 标题栏
            HStack {
                Button(action: prevMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .semibold))
                }
                .buttonStyle(.plain)

                Spacer()

                VStack(spacing: 1) {
                    Text(monthYearTitle)
                        .font(.system(size: 14, weight: .semibold))
                    Text(ganzhiText)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)

            // 星期标题行
            HStack(spacing: 0) {
                ForEach(Array(weekdayLabels.enumerated()), id: \.offset) { index, label in
                    Text(label)
                        .font(.system(size: 11))
                        .foregroundColor(index == 0 ? .red : .secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)

            Divider()

            // 月历网格
            MonthGridView(displayDate: displayDate)
                .padding(.horizontal, 8)

            Divider()

            // 今天按钮
            Button("今天") {
                displayDate = Date()
            }
            .buttonStyle(.plain)
            .font(.system(size: 12))
            .foregroundColor(.accentColor)
            .padding(.bottom, 8)
        }
        .frame(width: 320)
    }

    private var monthYearTitle: String {
        let cal = Calendar(identifier: .gregorian)
        let year = cal.component(.year, from: displayDate)
        let month = cal.component(.month, from: displayDate)
        return "\(year)年\(month)月"
    }

    private var ganzhiText: String {
        LunarCalendarHelper.ganzhiYear(for: displayDate)
    }

    private func prevMonth() {
        displayDate = Calendar.current.date(byAdding: .month, value: -1, to: displayDate) ?? displayDate
    }

    private func nextMonth() {
        displayDate = Calendar.current.date(byAdding: .month, value: 1, to: displayDate) ?? displayDate
    }
}
