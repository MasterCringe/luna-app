//
//  MenuView.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-06.
//

import SwiftUI

struct MenuView: View {
    @Binding var isPresented: Bool
    @Binding var showPersonalization: Bool
    @Binding var showProgression: Bool 

    var body: some View {
        NavigationView {
            List {
                
                Button(action: {
                    showProgression = true
                }) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Voir ma progression")
                    }
                }

                Button("Modifier Luna") {
                    showPersonalization = true
                    isPresented = false
                }
                .foregroundColor(.primary)

                Button("Fermer le menu") {
                    isPresented = false
                }
                .foregroundColor(.red)
                Button("Voir ma progression"){
                    showProgression = true
                    isPresented = false
                }
                .foregroundColor(.primary)
            }
            .navigationTitle("Menu")
            .fullScreenCover(isPresented: $showPersonalization) {
                PersonalizationView(isFirstLaunch: .constant(false))
            }
        }
    }
    struct MenuView_Previews: PreviewProvider {
        static var previews: some View {
            MenuView(isPresented: .constant(true),
                     showPersonalization: .constant(false), showProgression: .constant(false))
        }
    }
}
