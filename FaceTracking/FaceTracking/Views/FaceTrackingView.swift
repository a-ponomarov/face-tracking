//
//  FaceTrackingView.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import SwiftUI

struct FaceTrackingView : View {
    
    @StateObject var viewModel = FaceTrackingViewModel()
    
    @State var isRecording = false
    
    var body: some View {
        VStack {
            Text(viewModel.eyesLook.string)
                .font(.largeTitle)
                .frame(height: eyesLookTextHeight)
            ARViewContainer(delegate: viewModel)
            Text(viewModel.transcription)
        }
    }
    
    private let eyesLookTextHeight: CGFloat = 22
    
}
