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
    
    @Published var transcription = String()
    
    @Published var eyesLook = EyesLook()
    
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
    
    func session(_ session: ARSession,
                 didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {
        speechRecognizer.append(audioSampleBuffer: audioSampleBuffer)
    }
    
}
