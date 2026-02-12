//
//  DecibelTextView.swift
//  flux
//
//  Created by Xavier Chen on 1/2/26.
//

import SwiftUI

struct DecibelTextView: View {
    var amplitude: Float

    var decibelValue: Int {
        let minDBSPL: Float = 30.0
        let maxDBSPL: Float = 110.0
        let dbspl = minDBSPL + (amplitude * (maxDBSPL - minDBSPL))
        return Int(dbspl)
    }

    private var statusInfo:
        (text: String, message: String, exposure: String?, color: Color)
    {
        switch decibelValue {
        case ..<65:
            return (
                "Pleasant", "Gentle ripples. A comfortable environment.", nil,
                .cyan
            )
        case 65..<80:
            return (
                "Active", "Choppy waves. The room is getting busy.", nil, .green
            )
        case 80..<91:
            let time = decibelValue >= 88 ? "4 hours" : "8 hours"
            return (
                "Loud", "High tides. Be cautious of the volume.",
                "LIMIT: \(time)", .orange
            )
        case 91..<100:
            let time =
                decibelValue >= 97
                ? "30 mins" : (decibelValue >= 94 ? "1 hour" : "2 hours")
            return (
                "Intense", "Stormy seas. Hearing protection advised.",
                "LIMIT: \(time)", .red
            )
        case 100...:
            let time =
                decibelValue >= 109
                ? "2 mins"
                : (decibelValue >= 106
                    ? "4 mins" : (decibelValue >= 103 ? "8 mins" : "15 mins"))
            return (
                "Extreme", "Dangerous waves! Leave or use protection.",
                "LIMIT: < \(time)", .purple
            )
        default:
            return ("Ambient", "Scanning the horizon...", nil, .white)
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {

            // Status
            Text(statusInfo.text.uppercased())
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundStyle(statusInfo.color)

            HStack(alignment: .lastTextBaseline, spacing: 8) {
                // Decimal reading
                Text("\(decibelValue)")
                    .font(
                        .system(size: 140, weight: .black, design: .monospaced)
                    )
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(.white)

                // dB unit
                Text("dB")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
            }

            // Time limit
            ZStack {
                if let exposure = statusInfo.exposure {
                    Text(exposure.uppercased())
                        .font(
                            .system(
                                size: 14,
                                weight: .bold,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(statusInfo.color.opacity(0.8))
                        )
                }
            }
            .frame(height: 30)
            .padding(.top, -15)
            .padding(.bottom, 10)

            // Message
            Text(statusInfo.message)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(30)
    }
}
