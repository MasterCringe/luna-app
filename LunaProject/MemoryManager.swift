//
//  MemoryManager.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-06.
//

// MemoryManager.swift
// Gère la mémoire locale de Luna pour apprendre et évoluer

import Foundation

class MemoryManager: ObservableObject {
    static let shared = MemoryManager()
    
    // Historique des messages entre l’utilisateur et Luna
    @Published private(set) var conversationHistory: [String] = []
    
    // Dictionnaire de mémoire associée à des thèmes ou mots clés
    @Published private(set) var knowledgeBase: [String: [String]] = [:]
    
    private let historyKey = "conversationHistory"
    private let knowledgeKey = "lunaKnowledge"

    private init() {
        loadMemory()
    }
    
    // Ajouter une nouvelle phrase à l’historique
    func remember(_ message: String) {
        conversationHistory.append(message)
        saveMemory()
    }
    
    // Associer une idée à un mot-clé (ex: "chien" → ["J’adore les chiens !"])
    func associate(keyword: String, response: String) {
        if knowledgeBase[keyword] != nil {
            knowledgeBase[keyword]?.append(response)
        } else {
            knowledgeBase[keyword] = [response]
        }
        saveMemory()
    }
    
    // Rechercher une réponse possible pour un mot-clé
    func retrieve(for keyword: String) -> String? {
        guard let responses = knowledgeBase[keyword], !responses.isEmpty else { return nil }
        return responses.randomElement()
    }

    // Réinitialiser la mémoire (optionnel)
    func resetMemory() {
        conversationHistory.removeAll()
        knowledgeBase.removeAll()
        saveMemory()
    }
    
    // Sauvegarder localement (UserDefaults)
    private func saveMemory() {
        UserDefaults.standard.set(conversationHistory, forKey: historyKey)
        UserDefaults.standard.set(knowledgeBase, forKey: knowledgeKey)
    }

    // Charger la mémoire au démarrage
    private func loadMemory() {
        if let history = UserDefaults.standard.stringArray(forKey: historyKey) {
            conversationHistory = history
        }
        
        if let savedKnowledge = UserDefaults.standard.dictionary(forKey: knowledgeKey) as? [String: [String]] {
            knowledgeBase = savedKnowledge
        }
    }
}
