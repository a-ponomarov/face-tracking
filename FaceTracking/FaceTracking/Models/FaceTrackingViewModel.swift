//
//  FaceTrackingViewModel.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation
import CoreMedia.CMSampleBuffer
import ARKit

final class FaceTrackingViewModel: NSObject, ObservableObject {
    
    @Published var isRecording = false
    @Published var player: AVPlayer?
    
    func startWriting() {
        movieWriter.start()
        isRecording = true
        player = nil
    }
    
    func finishWriting() {
        Task {
            let url = await movieWriter.finish()
            await MainActor.run {
                videoURL = url
                player = AVPlayer(url: url)
                isRecording = false
            }
        }
    }
    
    @Published var videoURL: URL?
    
    @Published var eyesLook = EyesLook()
    @Published var transcription = String()
    
    override init() {
        super.init()
        speechRecognizer.$transcription.assign(to: &$transcription)
    }
    
    private let speechRecognizer = SpeechRecognizer()
    private let movieWriter = MovieWriter()

}

extension FaceTrackingViewModel: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let face = (anchors.first { $0 is ARFaceAnchor }) as? ARFaceAnchor else { return }
        eyesLook = face.eyesLook
    }
    
    func session(_ session: ARSession,
                 didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {
        speechRecognizer.append(audioSampleBuffer: audioSampleBuffer)
        if isRecording, let timestamp = session.currentFrame?.timestamp {
            movieWriter.append(sampleBuffer: audioSampleBuffer, timestamp: timestamp)
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if isRecording, let currentFrame = session.currentFrame {
            movieWriter.append(frame: currentFrame)
        }
    }
    
}
