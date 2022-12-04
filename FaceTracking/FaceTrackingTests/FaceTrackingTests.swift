//
//  FaceTrackingTests.swift
//  FaceTrackingTests
//
//  Created by Andrii Ponomarov on 04.12.2022.
//

import XCTest
@testable import FaceTracking

final class FaceTrackingTests: XCTestCase {

    func testEyesLookUpLeft() throws {
        let eyesLook = EyesLook(up: 0.33, left: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .visual(.remembered))
    }
    
    func testEyesLookUpRight() throws {
        let eyesLook = EyesLook(up: 0.33, right: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .visual(.constructed))
    }
    
    func testEyesLookLeft() throws {
        let eyesLook = EyesLook(left: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .auditory(.remembered))
    }
    
    func testEyesLookRight() throws {
        let eyesLook = EyesLook(right: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .auditory(.constructed))
    }
    
    func testEyesLookDownLeft() throws {
        let eyesLook = EyesLook(down: 0.33, left: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .auditoryDigital)
    }
    
    func testEyesLookDownRight() throws {
        let eyesLook = EyesLook(down: 0.33, right: 0.55)
        XCTAssert(eyesLook.direction.accessingCue == .kinesthetic)
    }

}
