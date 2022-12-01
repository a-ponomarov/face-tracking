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
    
    @Published var transcription: String = ""
    
    @Published var eyesLook = EyesLook(up: 0, down: 0, left: 0, right: 0)
    
    @Published var audioSampleBuffer: CMSampleBuffer? {
        didSet {
            guard let buffer = audioSampleBuffer else { return }
            speechRecognizer.append(audioSampleBuffer: buffer)
        }
    }
    
    override init() {
        super.init()
        speechRecognizer.$transcription.assign(to: &$transcription)
    }
    
    private let speechRecognizer = SpeechRecognizer()

}

extension FaceTrackingViewModel: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let face = (anchors.first { $0 is ARFaceAnchor }) as? ARFaceAnchor else { return }
        eyesLook = face.eyesLook
    }
    
    func session(_ session: ARSession, didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {
        self.audioSampleBuffer = audioSampleBuffer
    }
    
}
