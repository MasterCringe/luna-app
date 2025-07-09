//  LunaProject

// LunaBrain.swift
// Cerveau simple de Luna avec apprentissage local

import Foundation

class LunaBrain {
    
    // Référence au gestionnaire de mémoire partagé
    private let memory = MemoryManager.shared
    
    // Fonction principale qui reçoit un message et renvoie une réponse
    func receive(message: String) -> String {
        let lowercasedMessage = message.lowercased()
        
        // 🧠 Luna retient tout ce que tu lui dis
        memory.remember("Utilisateur : \(message)")
        
        // 🧠 Luna tente de trouver une réponse déjà associée à ce mot-clé
        let keywords = extractKeywords(from: lowercasedMessage)
        for keyword in keywords {
            if let learnedResponse = memory.retrieve(for: keyword) {
                return learnedResponse
            }
        }
        
        // 🤖 Si aucune réponse n’est trouvée, Luna improvise une réponse simple
        let fallbackResponse = defaultResponse(to: message)
        
        // 🧠 Elle apprend cette réponse pour la prochaine fois
        if let keyword = keywords.first {
            memory.associate(keyword: keyword, response: fallbackResponse)
        }
        
        // 🧠 Elle se souvient de sa propre réponse
        memory.remember("Luna : \(fallbackResponse)")
        
        return fallbackResponse
    }

    // 💬 Réponse par défaut si elle ne connaît pas le sujet
    private func defaultResponse(to message: String) -> String {
        return "T’as dit « \(message) » tantôt… tu veux continuer là-dessus ?"
    }

    // 🔎 Extraction très simple des mots-clés (on pourra améliorer plus tard)
    private func extractKeywords(from text: String) -> [String] {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { $0.count > 3 } // Ignore les mots trop courts
    }
}
