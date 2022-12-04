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
    
    init(up: Float = 0, down: Float = 0, left: Float = 0, right: Float = 0) {
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }
    
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
