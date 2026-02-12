//
//  StartStopButton.swift
//  flux
//
//  Created by Xavier Chen on 1/2/26.
//
import SwiftUI

struct StartStopButton: View {
    @Binding var isRunning: Bool
    @Binding var isSimulationMode: Bool
    
    var audioMonitor: AudioMonitor
    
    var body: some View {
        Button(action: toggleAppAction) {
            Label(
                isRunning ? "PAUSE" : "START",
                systemImage: isRunning ? "pause.fill" : "play.fill"
            )
            .font(.system(.headline, design: .monospaced))
            .padding()
            .frame(minWidth: 140)
            .background(.white)
            .foregroundStyle(.black)
            .clipShape(Capsule())
        }
    }
    
    private func toggleAppAction() {
        withAnimation(.spring()) {
            isRunning.toggle()
        }
        
        if isRunning && !isSimulationMode {
            Task {
                await audioMonitor.start()
            }
        } else {
            audioMonitor.stop()
        }
    }
}
