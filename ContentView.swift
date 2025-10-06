import SwiftUI

struct ContentView: View {
    @StateObject private var moonCalculator = MoonCalculator()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Moon Phase")
                    .font(.system(size: 36, weight: .thin))
                    .foregroundColor(.white)
                    .padding(.top, 60)

                // Moon visualization
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 250, height: 250)

                    MoonView(phase: moonCalculator.moonPhase)
                        .frame(width: 220, height: 220)
                }
                .padding(.vertical, 20)

                VStack(spacing: 12) {
                    Text(moonCalculator.phaseName)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)

                    Text("\(Int(moonCalculator.illumination * 100))% Illuminated")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                }

                VStack(spacing: 16) {
                    InfoRow(title: "Lunar Day", value: "\(moonCalculator.lunarDay)")
                    InfoRow(title: "Age", value: String(format: "%.1f days", moonCalculator.moonAge))
                    InfoRow(title: "Current Date", value: moonCalculator.currentDate)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)

                Button(action: {
                    moonCalculator.updateMoonPhase()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.15))
                    )
                }
                .padding(.top, 10)

                Spacer()
            }
        }
        .onAppear {
            moonCalculator.updateMoonPhase()
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct MoonView: View {
    let phase: Double

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                // Moon base
                Circle()
                    .fill(Color.white)
                    .frame(width: size, height: size)

                // Shadow overlay
                if phase < 0.5 {
                    // Waxing (0 to 0.5)
                    let shadowWidth = size * (1 - phase * 2)
                    Ellipse()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.15))
                        .frame(width: shadowWidth, height: size)
                        .offset(x: (size - shadowWidth) / 2)
                } else {
                    // Waning (0.5 to 1)
                    let shadowWidth = size * ((phase - 0.5) * 2)
                    Ellipse()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.15))
                        .frame(width: shadowWidth, height: size)
                        .offset(x: -(size - shadowWidth) / 2)
                }
            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    ContentView()
}
