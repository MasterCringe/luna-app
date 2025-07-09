//
//  HomeView.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bienvenue dans Luna 🌙")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Tu peux maintenant discuter avec ton IA personnalisée.")
                .multilineTextAlignment(.center)
                .padding()

            // Bouton temporaire pour réinitialiser l’onboarding
            Button(action: {
                UserDefaults.standard.set(1, forKey: "onboardingStep")
            }) {
                Text("🔄 Recommencer l’onboarding")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
