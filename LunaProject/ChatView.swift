//
//  ChatView.swift
//  LunaProject
//  Créé par Alexandre Coutu Robichaud le 2025-07-03
//

import SwiftUI
import Speech

// MARK: - Structure d’un message
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isFromLuna: Bool
}

struct ChatView: View {
    // MARK: - États
    @State private var showMenu = false
    @State private var isPresentingPersonalization = false
    @State private var showPersonalization = false
    @State private var messages: [Message] = [
        Message(text: "Salut !", isFromLuna: true)
    ]
    @State private var userInput: String = ""
    @State private var isRecording = false
    @State private var showProgression = false
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - ViewModels
    @StateObject var speechVM = SpeechViewModel()
    @StateObject var luna = LunaCore()
    let brain = LunaBrain()

    // Scroll automatique vers le bas
    @Namespace var bottomID

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // En-tête
                chatHeader

                // Liste des messages
                ScrollViewReader { proxy in
                    ScrollView {
                        chatMessages(proxy: proxy)
                            .padding(.bottom, 16) // espace sous les messages
                    }
                    .onTapGesture {
                        isTextFieldFocused = false // Masque le clavier
                    }
                    .onChange(of: messages.count) {
                        withAnimation {
                            proxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                }
            }

            // Barre de saisie ancrée en bas
            inputBarView
                .background(Color.black)
                
        }
        .background(Color.black.ignoresSafeArea())
        .keyboardResponsive()
        .ignoresSafeArea(.keyboard, edges: .bottom) // ⬅️ Important pour que le clavier ne cache rien

        // Menu accessible en haut à gauche
        .sheet(isPresented: $showMenu) {
            MenuView(
                isPresented: $showMenu,
                showPersonalization: $showPersonalization,
                showProgression: $showProgression // 👈 ici
            )
        }

        // Vue de personnalisation
        .fullScreenCover(isPresented: $isPresentingPersonalization) {
            PersonalizationView(isFirstLaunch: .constant(false))
        }

        // Vue de progression
        .sheet(isPresented: $showProgression) {
            ProgressionView(showProgression: $showProgression) // 👈 ici
        }

    }

    // MARK: - Barre de saisie avec micro et bouton envoyer
    private var inputBarView: some View {
        VStack(spacing: 0) {
            Divider().background(Color.gray.opacity(0.2)) // ligne au-dessus

            HStack(spacing: 10) {
                // Bouton +
                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }

                // Champ de texte
                TextField("Écris ici...", text: $userInput)
                    .padding(10)
                    .background(Color(.darkGray))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .focused($isTextFieldFocused)

                // Micro
                Button(action: {
                    isRecording.toggle()
                    if isRecording {
                        speechVM.startRecording { transcription in
                            userInput = transcription
                        }
                    } else {
                        speechVM.stopRecording()
                    }
                }) {
                    Image(systemName: isRecording ? "mic.circle.fill" : "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(isRecording ? .red : .gray)
                }

                // Envoyer
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(userInput.isEmpty ? .gray : .blue)
                }
                .disabled(userInput.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.black)
        }
    }

    // MARK: - En-tête du chat
    private var chatHeader: some View {
        HStack {
            // Bouton du menu (≡)
            Button(action: {
                showMenu = true
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("Luna")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                Text(luna.emotion.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            // Espace vide pour équilibrer le HStack
            Image(systemName: "line.horizontal.3")
                .foregroundColor(.clear)
                .font(.title2)
        }
        .padding()
        .background(Color.black)
    }

    // MARK: - Affichage des messages
    private func chatMessages(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 12) {
            ForEach(messages) { message in
                HStack(alignment: .bottom) {
                    if message.isFromLuna {
                        Text(message.text)
                            .padding(12)
                            .background(Color.purple.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .frame(maxWidth: 250, alignment: .leading)
                        Spacer()
                    } else {
                        Spacer()
                        Text(message.text)
                            .padding(12)
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .frame(maxWidth: 250, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
            }

            // Scroll vers le bas
            Rectangle().frame(height: 0).id(bottomID)
        }
        .padding(.top, 10)
    }

    // MARK: - Envoi d’un message
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        messages.append(Message(text: userInput, isFromLuna: false))

        let response = brain.receive(message: userInput)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(Message(text: response, isFromLuna: true))
        }

        userInput = ""
    }
}
