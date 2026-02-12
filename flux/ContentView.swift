//
//  ContentView.swift
//  flux
//
//  Created by Xavier Chen on 24/1/26.
//

import Foundation
import RealityKit
import SwiftUI

struct ContentView: View {
    @State private var audioMonitor = AudioMonitor()
    @State private var isSimulationMode = false
    @State private var debugAmplitude: Float = 0.5
    @State private var isRunning = false
    @State private var showSettings = false
    @State private var selectedBoat: BoatType = .rubberDuck
    @State private var showInfo = false

    var amplitudeSource: Float {
        isSimulationMode ? debugAmplitude : audioMonitor.amplitude
    }

    // Helper variable to calculate padding based on physical screen height
    private var deviceTopPadding: CGFloat {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene
        else {
            return 0
        }

        let bounds = windowScene.screen.bounds
        let width = bounds.width
        let height = bounds.height
        let isLandscape = width > height

        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                // LANDSCAPE MODE
                // 13-inch iPad width is approx 1366pt
                // 11-inch iPad width is approx 1194pt
                return width > 1300 ? 60 : 20
            } else {
                // PORTRAIT MODE
                // 13-inch iPad width is approx 1024pt
                // 11-inch iPad width is approx 834pt
                return width > 1000 ? 170 : 120
            }
        } else {
            // iPhone
            return 0
        }
    }

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            // Ocean view
            OceanSceneView(
                amplitude: isRunning ? amplitudeSource : 0,
                boatType: selectedBoat
            )
            .ignoresSafeArea()
            .opacity(isRunning ? 1.0 : 0.6)
            .animation(.easeInOut, value: isRunning)

            // Main UI layer
            VStack(spacing: 20) {
                // Decibel reading
                DecibelTextView(amplitude: isRunning ? amplitudeSource : 0)
                    .padding(.top, deviceTopPadding)

                Spacer()

                // Settings
                if showSettings {
                    SettingsView(
                        isSimulationMode: $isSimulationMode,
                        selectedBoat: $selectedBoat
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Action buttons
                HStack(spacing: 20) {
                    StartStopButton(
                        isRunning: $isRunning,
                        isSimulationMode: $isSimulationMode,
                        audioMonitor: audioMonitor
                    )

                    InfoToggleButton(showInfo: $showInfo)

                    SettingsToggleButton(showSettings: $showSettings)
                }
                .padding(.bottom, 50)
                .sheet(isPresented: $showInfo) {
                    InfoView()
                }

                // Simulation Slider
                if isSimulationMode && isRunning {
                    Slider(value: $debugAmplitude, in: 0...1)
                        .tint(.white)
                        .padding(.horizontal, 40)
                        .padding(.top, -30)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
