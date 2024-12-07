import SwiftUI
import Charts

struct DailySpendingChart: View {
    let data: [Date: Double]

    var body: some View {
        GeometryReader { geo in
            let sortedDates = data.keys.sorted()
            let entries = sortedDates.enumerated().map { (index, day) in
                (x: Double(index), date: day, amount: data[day] ?? 0.0)
            }

            Chart {
                ForEach(entries, id: \.x) { entry in
                    LineMark(
                        x: .value("Day", entry.x),
                        y: .value("Amount", entry.amount)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    if let index = value.as(Double.self), index < Double(sortedDates.count) {
                        let day = sortedDates[Int(index)]
                        AxisValueLabel(formatDate(day))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
