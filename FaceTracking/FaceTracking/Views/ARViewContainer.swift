//
//  ARViewContainer.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    weak var delegate: ARSessionDelegate?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            configuration.providesAudioData = true
            arView.session.run(configuration, options: .removeExistingAnchors)
            arView.session.delegate = delegate
        }
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
