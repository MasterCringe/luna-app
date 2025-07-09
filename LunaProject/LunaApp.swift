//
//  LunaApp.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-03.
//

import SwiftUI

@main
struct LunaApp: App {
    // On utilise AppStorage pour se souvenir si l'app a déjà été lancée
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var showProgression = true
    
    var body: some Scene {
        WindowGroup {
            if showProgression {
                ProgressionView(showProgression: $showProgression)
            } else {
                if isFirstLaunch {
                    PersonalizationView(isFirstLaunch: $isFirstLaunch)
                } else {
                    ChatView()
                }
            }
        }
    }
}
