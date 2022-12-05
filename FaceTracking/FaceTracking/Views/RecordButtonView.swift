//
//  RecordButtonView.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 05.12.2022.
//

import SwiftUI

struct RecordButtonView: View {
    
    @Binding var isRecording: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button { action() } label: {
            Image(systemName: isRecording ? "stop.fill" : "record.circle")
                .font(.largeTitle)
                .padding()
        }
    }
}
