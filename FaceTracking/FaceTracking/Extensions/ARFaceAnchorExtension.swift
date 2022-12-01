//
//  ARFaceAnchorExtension.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation
import ARKit.ARFaceAnchor

extension ARFaceAnchor {
    
    var eyesLook: EyesLook {
        let up = blendShapes[.eyeLookUpRight] ?? blendShapes[.eyeLookUpLeft]
        let down = blendShapes[.eyeLookDownRight] ?? blendShapes[.eyeLookDownLeft]
        let left = blendShapes[.eyeLookInLeft]
        let right = blendShapes[.eyeLookInRight]
        
        return EyesLook(up: up?.floatValue ?? 0,
                        down: down?.floatValue ?? 0,
                        left: left?.floatValue ?? 0,
                        right: right?.floatValue ?? 0)
    }

}
