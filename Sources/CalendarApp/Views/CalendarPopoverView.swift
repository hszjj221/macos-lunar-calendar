import SwiftUI

struct CalendarPopoverView: View {
    @State private var displayDate: Date = Date()
    @State private var today: Date = Date()

    private let weekdayLabels = ["日","一","二","三","四","五","六"]

    var body: some View {
        VStack(spacing: 8) {
            // 标题栏
            HStack {
                Button(action: prevMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("上个月")
                .accessibilityLabel("上个月")

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
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("下个月")
                .accessibilityLabel("下个月")
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
            MonthGridView(displayDate: displayDate, today: today)
                .padding(.horizontal, 8)

            Divider()

            // 今天按钮
            Button("今天") {
                refreshToToday()
            }
            .buttonStyle(.plain)
            .font(.system(size: 12))
            .foregroundColor(.accentColor)
            .help("回到今天")
            .accessibilityLabel("今天")
            .padding(.bottom, 8)
        }
        .frame(width: 320)
        .onAppear {
            refreshToToday()
        }
    }

    private var monthYearTitle: String {
        let calendar = AppCalendars.gregorian
        let year = calendar.component(.year, from: displayDate)
        let month = calendar.component(.month, from: displayDate)
        return "\(year)年\(month)月"
    }

    private var ganzhiText: String {
        LunarCalendarHelper.ganzhiYear(for: displayDate)
    }

    private func prevMonth() {
        displayDate = AppCalendars.gregorian.date(byAdding: .month, value: -1, to: displayDate) ?? displayDate
    }

    private func nextMonth() {
        displayDate = AppCalendars.gregorian.date(byAdding: .month, value: 1, to: displayDate) ?? displayDate
    }

    private func refreshToToday() {
        let now = Date()
        today = now
        displayDate = now
    }
}
