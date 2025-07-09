//
//  PersonalizationView.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-03.
//

import SwiftUI

struct PersonalizationView: View {
    @Binding var isFirstLaunch: Bool
    @State private var showLuna = false

    var body: some View {
        VStack(spacing: 20) {
            
            // Image de Luna avec animation
            if showLuna {
                Image("LunaAvatar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeOut(duration: 1.0), value: showLuna)
            }

            Text("Écran de personnalisation 🛠️")
                .font(.title)
                .opacity(showLuna ? 1 : 0)
                .animation(.easeIn.delay(0.5), value: showLuna)

            Button("Terminer") {
                isFirstLaunch = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .opacity(showLuna ? 1 : 0)
            .animation(.easeIn.delay(0.8), value: showLuna)
        }
        .padding()
        .onAppear {
            showLuna = true
        }
    }
}
#Preview {
    PersonalizationView(isFirstLaunch: .constant(true))
}
