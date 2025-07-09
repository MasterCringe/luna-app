//  ProgressionView.swift
//  LunaProject
//  Vue temporaire de suivi du développement

import SwiftUI

struct ProgressionView: View {
    @Binding var showProgression: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("🧪 LUNA – PROJET EN COURS")
                    .font(.title2).bold()
                    .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Étape 1 : Moteur local connecté à LM Studio", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)

                    Label("Étape 2 : Réponses en temps réel dans l'app iOS", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)

                    Label("Étape 3 : Mémoire autonome de Luna", systemImage: "circle")
                        .foregroundColor(.gray)

                    Label("Étape 4 : Génération d'images et vidéos (bientôt)", systemImage: "circle")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    showProgression = false
                }) {
                    Text("🚀 Continuer vers Luna")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// Exemple d'aperçu pour test
struct ProgressionView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionView(showProgression: .constant(true))
    }
}
