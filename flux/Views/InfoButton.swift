//
//  InfoButton.swift
//  flux
//
//  Created by Xavier Chen on 2/2/26.
//

import SwiftUI

struct InfoToggleButton: View {
    @Binding var showInfo: Bool
    
    var body: some View {
        Button {
            showInfo.toggle()
        } label: {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .foregroundStyle(.white)
        }
    }
}
