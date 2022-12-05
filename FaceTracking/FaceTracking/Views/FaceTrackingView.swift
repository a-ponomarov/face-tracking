//
//  FaceTrackingView.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import SwiftUI
import AVKit

struct FaceTrackingView : View {
    
    @StateObject var viewModel = FaceTrackingViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.eyesLook.string)
                .font(.largeTitle)
                .frame(height: eyesLookTextHeight)
            Text(viewModel.transcription)
            ARViewContainer(delegate: viewModel)
                .overlay(alignment: .bottomTrailing) {
                    RecordButtonView(isRecording: $viewModel.isRecording) {
                        viewModel.isRecording ? viewModel.finishWriting() : viewModel.startWriting()
                    }
            }
            VideoPlayer(player: viewModel.player)
        }
    }
    
    private let eyesLookTextHeight: CGFloat = 22
    
}
