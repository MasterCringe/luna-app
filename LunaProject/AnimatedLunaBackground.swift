//
//  AnimatedLunaBackground.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-03.
//

import SwiftUI

struct AnimatedLunaBackground: View {
    @State private var isBlinking = false

    var body: some View {
        ZStack {
            // Fond dégradé doux
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Avatar Luna animé (ex. effet clignement ou respiration)
            Image("LunaAvatar") // Remplace par le nom exact de l'image de Luna
                .resizable()
                .scaledToFit()
                .opacity(isBlinking ? 1.0 : 0.97)
                .scaleEffect(isBlinking ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isBlinking)
                .onAppear {
                    isBlinking = true
                }
        }
    }
}
