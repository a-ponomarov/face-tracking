//
//  MovieWriter.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 04.12.2022.
//

import Foundation
import AVFoundation
import ARKit.ARFrame

class MovieWriter {
    
    func append(sampleBuffer: CMSampleBuffer, timestamp: TimeInterval) {
        
        var count: CMItemCount = 0
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer,
                                               entryCount: 0,
                                               arrayToFill: nil,
                                               entriesNeededOut: &count)
        
        var info = Array(repeating: CMSampleTimingInfo(), count: count)
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer,
                                               entryCount: count,
                                               arrayToFill: &info,
                                               entriesNeededOut: &count)
        
        let currentTime = timestamp.cmTime
        
        if startTime == .zero {
            startTime = currentTime
        }
        
        let audioTime = currentTime - startTime
        
        for index in 0..<count {
            info[index].decodeTimeStamp = audioTime
            info[index].presentationTimeStamp = audioTime
        }
        
        var audioBuffer: CMSampleBuffer?
        
        CMSampleBufferCreateCopyWithNewTiming(allocator: kCFAllocatorDefault,
                                              sampleBuffer: sampleBuffer,
                                              sampleTimingEntryCount: count,
                                              sampleTimingArray: &info,
                                              sampleBufferOut: &audioBuffer)
        
        if audioInput?.isReadyForMoreMediaData ?? false, let audioBuffer = audioBuffer {
            audioInput?.append(audioBuffer)
        }
    }
    
    func append(frame: ARFrame) {
        
        guard lastTimestamp == 0 || lastTimestamp + 1 / Double(fps) < frame.timestamp else { return }

        let currentTime = frame.timestamp.cmTime
        
        if lastTimestamp == 0 {
            startTime = currentTime
        }
        lastTimestamp = frame.timestamp
        
        if videoInput?.isReadyForMoreMediaData ?? false {
            pixelBufferAdaptor?.append(frame.capturedImage, withPresentationTime: currentTime - startTime)
        }
    }
    
    func start() {
        setup()
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: .zero)
    }
    
    func finish() async -> URL {
        audioInput?.markAsFinished()
        videoInput?.markAsFinished()
        return await withCheckedContinuation { continuation in
            assetWriter?.finishWriting {
                continuation.resume(returning: self.outputURL)
                self.reset()
            }
        }
    }
    
    private func reset() {
        audioInput = nil
        videoInput = nil
        pixelBufferAdaptor = nil
        assetWriter = nil
        startTime = .zero
        lastTimestamp = 0
    }
    
    private func setup() {
        do { assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov) }
        catch { fatalError() }
        
        let audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
        audioInput.expectsMediaDataInRealTime = true
        
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: nil)
        videoInput.expectsMediaDataInRealTime = true
        videoInput.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        let pixelBufferAdaptor =
        AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput)
        
        self.audioInput = audioInput
        self.videoInput = videoInput
        self.pixelBufferAdaptor = pixelBufferAdaptor
        
        assetWriter?.add(audioInput)
        assetWriter?.add(videoInput)
    }

    private let outputURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString + videoExtension)
    }()
    
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var assetWriter: AVAssetWriter?

    private var audioInput: AVAssetWriterInput?
    private var videoInput: AVAssetWriterInput?
    
    private var startTime: CMTime = .zero
    private var lastTimestamp: TimeInterval = 0
    
    private let fps: Int = 10
    static private let videoExtension = ".mov"

}

private extension TimeInterval {
    
    var cmTime: CMTime {
        CMTime(value: CMTimeValue(self * Double(NSEC_PER_SEC)), timescale: CMTimeScale(NSEC_PER_SEC))
    }
    
}

