//
//  EyesDirection.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation

enum EyesDirection: String {
    
    case straight, right, left, upRight, downRight, upLeft, downLeft
    
    var accessingCue: AccessingCue? {
        switch self {
        case .right:
            return .auditory(.constructed)
        case .upRight:
            return .visual(.constructed)
        case .downRight:
            return .kinesthetic
        case .left:
            return .auditory(.remembered)
        case .upLeft:
            return .visual(.remembered)
        case .downLeft:
            return .auditoryDigital
        case .straight:
            return nil
        }
    }

}
