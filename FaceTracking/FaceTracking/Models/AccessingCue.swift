//
//  AccessingCue.swift
//  FaceTracking
//
//  Created by Andrii Ponomarov on 01.12.2022.
//

import Foundation

enum AccessingCue: Equatable {
    
    case visual(Memory), auditory(Memory), kinesthetic, auditoryDigital
    
    enum Memory: String {
        case constructed, remembered
    }
    
    var string: String {
        switch self {
        case .visual(let memory):
            return "visual \(memory)"
        case .auditory(let memory):
            return "auditory \(memory)"
        case .kinesthetic:
            return "kinesthetic"
        case .auditoryDigital:
            return "auditory digital"
        }
    }
    
}
