//
//  SpeechRecognizer.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation
import Speech

class SpeechRecognizer: ObservableObject {

    @Published var transcription: String = ""

    init() {
        recognizer = SFSpeechRecognizer()
        Task {
            do {
                guard await SFSpeechRecognizer.isAuthorizedToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                start()
            } catch {
                handleError(error)
            }
        }
    }

    deinit {
        reset()
    }

    func reset() {
        task?.cancel()
        request = nil
        task = nil
    }

    func start() {
        guard recognizer?.isAvailable ?? false else {
            handleError(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        
        self.task = recognizer?.recognitionTask(with: request) { [weak self] result, error in
            if let error {
                self?.handleError(error)
            }
            guard let result else { return }
            self?.transcription = result.bestTranscription.formattedString
        }
    }
    
    func append(audioSampleBuffer: CMSampleBuffer) {
        request?.appendAudioSampleBuffer(audioSampleBuffer)
    }

    private func handleError(_ error: Error) {
        if let error = error as? RecognizerError {
            transcription = error.message
        } else {
            transcription = error.localizedDescription
        }
    }

    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?

}

private extension SFSpeechRecognizer {

    static func isAuthorizedToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

}

private enum RecognizerError: Error {

    case nilRecognizer
    case notAuthorizedToRecognize
    case recognizerIsUnavailable

    var message: String {
        switch self {
        case .nilRecognizer:
            return "Can't initialize speech recognizer"
        case .notAuthorizedToRecognize:
            return "Not authorized to recognize speech"
        case .recognizerIsUnavailable:
            return "Recognizer is unavailable"
        }
    }
}
