//
//  SettingsButton.swift
//  flux
//
//  Created by Xavier Chen on 1/2/26.
//

import SwiftUI

struct SettingsToggleButton: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showSettings.toggle()
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .foregroundStyle(showSettings ? .blue : .white)
                .rotationEffect(.degrees(showSettings ? 90 : 0))
        }
    }
}
