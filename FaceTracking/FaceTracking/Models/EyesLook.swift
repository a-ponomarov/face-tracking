//
//  EyesLook.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation

struct EyesLook {

    let up: Float
    let down: Float
    let left: Float
    let right: Float
    
    var direction: EyesDirection {
        if left > threshold {
            return up > threshold ? .upLeft : down > threshold ? .downLeft : .left
        } else if right > threshold {
            return up > threshold ? .upRight : down > threshold ? .downRight : .right
        }
        return .straight
    }
    
    var string: String {
        return direction.accessingCue?.string ?? ""
    }
    
    private let threshold: Float = 0.22

}
