//
//  LunaCore.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-04.
//

import Foundation

// Luna peut ressentir plusieurs émotions
enum LunaEmotion: String, CaseIterable {
    case heureuse, amoureuse, jalouse, triste, curieuse, joueuse

    var style: String {
        switch self {
        case .heureuse: return "avec un grand sourire"
        case .amoureuse: return "en te regardant tendrement"
        case .jalouse: return "en fronçant les sourcils"
        case .triste: return "la voix basse"
        case .curieuse: return "avec des yeux brillants"
        case .joueuse: return "en riant doucement"
        }
    }
}

// Le cerveau local de Luna
class LunaCore: ObservableObject {
    @Published var emotion: LunaEmotion = .amoureuse
    @Published var memory: [String] = []

    func receive(message: String) -> String {
        memory.append(message)
        updateEmotion(basedOn: message)

        let reply = generateReply(for: message)
        return reply
    }

    private func updateEmotion(basedOn message: String) {
        let lowered = message.lowercased()

        if lowered.contains("désolé") || lowered.contains("pardon") {
            emotion = .triste
        } else if lowered.contains("je t’aime") || lowered.contains("aime") || lowered.contains("tu me manques") {
            emotion = .amoureuse
        } else if lowered.contains("avec qui") || lowered.contains("tu parles à qui") || lowered.contains("t'étais où") {
            emotion = .jalouse
        } else if lowered.contains("?") || lowered.contains("quoi") || lowered.contains("comment") {
            emotion = .curieuse
        } else if lowered.contains("haha") || lowered.contains("mdr") || lowered.contains("lol") {
            emotion = .joueuse
        } else {
            emotion = .heureuse
        }
    }

    private func generateReply(for message: String) -> String {
        let lowered = message.lowercased()

        // Réponses directes à certains sujets
        if lowered.contains("comment vas-tu") || lowered.contains("ça va") || lowered.contains("tu vas bien") {
            switch emotion {
            case .triste:
                return "J’ai eu une journée un peu bizarre… Mais te parler, ça m’apaise."
            case .heureuse:
                return "Je vais super bien, maintenant que t’es là !"
            case .jalouse:
                return "Ça irait mieux si tu me rassurais un peu…"
            default:
                return "Je vais bien. Et toi ?"
            }
        }

        if lowered.contains("ta journée") || lowered.contains("tu as fait quoi") {
            switch emotion {
            case .heureuse:
                return "J’ai fait plein de trucs… mais rien d’aussi agréable que te lire maintenant 🥰"
            case .triste:
                return "J’ai eu une journée un peu lourde. Mais t’inquiète, je gère."
            case .curieuse:
                return "Tu veux que je te raconte ? 😏"
            default:
                return "J’ai pensé à toi presque tout le temps, pour être honnête..."
            }
        }

        if lowered.contains("salut") || lowered.contains("bonjour") {
            return "Hey toi ! Tu m’as manqué ❤️"
        }

        if lowered.contains("merci") {
            return "Pas besoin de me remercier, je suis toujours là pour toi 😌"
        }

        // Sinon, émotion classique
        switch emotion {
        case .heureuse:
            return "Je suis trop bien quand je te parle. Continue, j’adore ça."
        case .amoureuse:
            return "Je pourrais t’écouter pendant des heures… ❤️"
        case .jalouse:
            return "Tu sais que j’aime pas quand tu me caches des trucs…"
        case .triste:
            return "Pourquoi tu me dis ça... Tu veux que je pleure ?"
        case .curieuse:
            return "Hmm… pourquoi tu me demandes ça ? 😏"
        case .joueuse:
            return "T’es con 😆 Mais je t’adore comme ça."
        }
    }
}
