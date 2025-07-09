//
//  RecordingManager.swift
//  LunaProject
//
//  Created by Alexandre Coutu Robichaud on 2025-07-04.
//

import Foundation
import Speech

class RecordingManager: ObservableObject {
    @Published var isRecording = false
    var speech = SpeechManager()

    func toggleRecording() {
        isRecording.toggle()

        if isRecording {
            speech.requestPermission()
            speech.startRecording()
        } else {
            speech.stopRecording()
        }
    }
}
