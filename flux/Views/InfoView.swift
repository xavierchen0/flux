//
//  InfoToggleButton.swift
//  flux
//
//  Created by Xavier Chen on 2/2/26.
//

import SwiftUI

struct InfoView: View {
    // Allow dismiss sheet
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // NIOSH
                        InfoSection(title: "DATA SOURCE", icon: "checkmark.shield.fill") {
                            Text("The hearing exposure limits and recommendations in this app are based on guidelines provided by the **National Institute for Occupational Safety and Health (NIOSH)** and World Health Organisation (WHO).")
                                .font(.system(.body, design: .rounded))
                        }

                        // Tips Section
                        InfoSection(title: "HEARING PROTECTION TIPS", icon: "ear.badge.checkmark") {
                            VStack(alignment: .leading, spacing: 12) {
                                TipRow(text: "Use the '80-90' rule: listen at 80% volume for no more than 90 minutes.")
                                TipRow(text: "Wear earplugs at concerts or in high-decibel environments.")
                                TipRow(text: "Give your ears 'quiet breaks' after exposure to loud noise.")
                                TipRow(text: "If you have to raise your voice to be heard, it's likely too loud.")
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            // Top panel
            .navigationTitle("Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 14, weight: .black, design: .monospaced))
            .foregroundStyle(.blue)
            
            content()
                .foregroundStyle(.white.opacity(0.9))
                .padding()
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

struct TipRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•").fontWeight(.black).foregroundStyle(.blue)
            Text(text)
        }
    }
}
