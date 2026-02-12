//
//  SettingsView.swift
//  flux
//
//  Created by Xavier Chen on 1/2/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isSimulationMode: Bool
    @Binding var selectedBoat: BoatType

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Choose boat header
            HStack {
                Text("SHIPYARD")
                    .font(
                        .system(size: 14, weight: .black, design: .monospaced)
                    )
                    .foregroundStyle(.secondary)
                Spacer()

                // Icon to indicate scroll right
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.5))
            }

            // Choose boat
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 12) {
                    ForEach(BoatType.allCases) { boat in
                        BoatCard(
                            boat: boat,
                            isSelected: selectedBoat == boat
                        )
                        .onTapGesture {
                            withAnimation(
                                .spring(response: 0.3, dampingFraction: 0.7)
                            ) {
                                selectedBoat = boat
                            }
                        }
                        // Ensure there is only 3 items shown when settings is opened
                        .containerRelativeFrame(
                            .horizontal,
                            count: 3,
                            spacing: 12
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .frame(height: 110)

            Divider()
                .background(.white.opacity(0.2))

            // Whether to toggle simulation mode
            Toggle(isOn: $isSimulationMode.animation(.spring())) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .symbolEffect(.bounce, value: isSimulationMode)
                    Text("Manual Simulation")
                }
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(.primary)
            }
            .tint(.blue)
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}

struct BoatCard: View {
    let boat: BoatType
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            // Icon
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.black.opacity(0.05))
                    .frame(width: 48, height: 48)
                Text(boat.icon)
                    .font(.system(size: 24))
                    .shadow(radius: isSelected ? 2 : 0)
            }

            // Text
            Text(boat.rawValue)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? .blue : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            isSelected ? Color.blue.opacity(0.1) : Color.white.opacity(0.05)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .opacity(isSelected ? 1.0 : 0.8)
    }
}
