//
//  SpeechViewModel.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-04.
//


import Foundation
import Speech
import AVFoundation

class SpeechViewModel: NSObject, ObservableObject {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr-FR"))
    private var silenceTimer: Timer?

    // Lance l'enregistrement et retourne le texte transcrit via le callback
    func startRecording(onResult: @escaping (String) -> Void) {
        requestPermission()

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                onResult(result.bestTranscription.formattedString)
                self.resetSilenceTimer(onTimeout: {
                    self.stopRecording()
                })
            }
        }

        // Démarre un timer de silence initial
        resetSilenceTimer(onTimeout: {
            self.stopRecording()
        })
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        silenceTimer?.invalidate()
    }

    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            if status != .authorized {
                print("Permission micro refusée")
            }
        }
    }

    private func resetSilenceTimer(onTimeout: @escaping () -> Void) {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            onTimeout()
        }
    }
}
