import Foundation

class MoonCalculator: ObservableObject {
    @Published var moonPhase: Double = 0.0
    @Published var moonAge: Double = 0.0
    @Published var lunarDay: Int = 0
    @Published var illumination: Double = 0.0
    @Published var phaseName: String = ""
    @Published var currentDate: String = ""

    private let synodicMonth: Double = 29.53058867 // Average lunar cycle in days

    func updateMoonPhase() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        // Known new moon: January 6, 2000, 18:14 UTC
        let knownNewMoon = createDate(year: 2000, month: 1, day: 6, hour: 18, minute: 14)!
        let daysSinceKnownNewMoon = date.timeIntervalSince(knownNewMoon) / 86400

        moonAge = daysSinceKnownNewMoon.truncatingRemainder(dividingBy: synodicMonth)
        moonPhase = moonAge / synodicMonth
        lunarDay = Int(moonAge) + 1

        // Calculate illumination
        illumination = (1 - cos(moonPhase * 2 * .pi)) / 2

        // Determine phase name
        phaseName = getPhaseName(phase: moonPhase)

        // Format current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        currentDate = dateFormatter.string(from: date)
    }

    private func getPhaseName(phase: Double) -> String {
        switch phase {
        case 0..<0.0625, 0.9375...1.0:
            return "New Moon"
        case 0.0625..<0.1875:
            return "Waxing Crescent"
        case 0.1875..<0.3125:
            return "First Quarter"
        case 0.3125..<0.4375:
            return "Waxing Gibbous"
        case 0.4375..<0.5625:
            return "Full Moon"
        case 0.5625..<0.6875:
            return "Waning Gibbous"
        case 0.6875..<0.8125:
            return "Last Quarter"
        case 0.8125..<0.9375:
            return "Waning Crescent"
        default:
            return "Unknown"
        }
    }

    private func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone(identifier: "UTC")
        return Calendar.current.date(from: components)
    }
}
