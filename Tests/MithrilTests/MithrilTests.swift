//
//  MithrilTests.swift
//  MithrilTests
//
//  Unit tests for Mithril Animation Studio
//

import XCTest
import SwiftUI
@testable import Mithril

final class MithrilTests: XCTestCase {
    
    func testAnimatableProtocol() {
        // Test that View conforms to Animatable
        let view = Text("Test")
        let animationBuilder = view.mithril()
        
        XCTAssertNotNil(animationBuilder)
    }
    
    func testAnimationBuilderChaining() {
        // Test basic chaining
        let view = Rectangle()
        let builder = view
            .mithril()
            .fadeIn()
            .then()
            .scaleUp()
            .and()
            .rotate(degrees: 90)
        
        XCTAssertNotNil(builder)
    }
    
    func testAnimationPresets() {
        // Test preset creation
        let fadeInUp = AnimationPreset.fadeInUp
        XCTAssertFalse(fadeInUp.steps.isEmpty)
        
        let bounce = AnimationPreset.bounce
        XCTAssertFalse(bounce.steps.isEmpty)
        
        let socialLike = AnimationPreset.socialLike
        XCTAssertFalse(socialLike.steps.isEmpty)
    }
    
    func testCustomPreset() {
        // Test custom preset creation
        let customPreset = AnimationPreset.custom([
            .fadeIn(duration: 0.3),
            .scaleUp(to: 1.2, duration: 0.3)
        ])
        
        XCTAssertEqual(customPreset.steps.count, 2)
    }
    
    func testSpringTypes() {
        // Test spring animation types
        let smoothSpring = SpringType.smooth
        let snappySpring = SpringType.snappy
        let bouncySpring = SpringType.bouncy
        let wobblySpring = SpringType.wobbly
        let customSpring = SpringType.custom(tension: 400, friction: 25)
        
        XCTAssertNotNil(smoothSpring.animation)
        XCTAssertNotNil(snappySpring.animation)
        XCTAssertNotNil(bouncySpring.animation)
        XCTAssertNotNil(wobblySpring.animation)
        XCTAssertNotNil(customSpring.animation)
    }
    
    func testSlideDirections() {
        // Test slide direction enum
        let directions: [SlideDirection] = [
            .up, .down, .left, .right,
            .topLeading, .topTrailing, .bottomLeading, .bottomTrailing
        ]
        
        XCTAssertEqual(directions.count, 8)
    }
    
    func testShakeDirections() {
        // Test shake direction enum
        let directions: [ShakeDirection] = [.horizontal, .vertical, .both]
        XCTAssertEqual(directions.count, 3)
    }
    
    func testRepeatModes() {
        // Test repeat mode enum
        let modes: [RepeatMode] = [
            .once,
            .forever,
            .times(3),
            .duration(2.0)
        ]
        
        XCTAssertEqual(modes.count, 4)
    }
    
    func testParallelAnimations() {
        let animation = Text("Test")
            .mithril()
            .scaleDown(to: 0.8)
            .and()
            .rotate(Angle.degrees(45))
        
        XCTAssertEqual(animation.steps.count, 1)
        
        if case .parallelGroup(let parallelSteps) = animation.steps.first {
            XCTAssertEqual(parallelSteps.count, 2)
            
            // Verify the parallel steps are scaleDown and rotate
            if case .scaleDown(let scale, _) = parallelSteps[0] {
                XCTAssertEqual(scale, 0.8)
            } else {
                XCTFail("Expected scaleDown as first parallel step")
            }
            
            if case .rotate(let angle, _) = parallelSteps[1] {
                XCTAssertEqual(angle, Angle.degrees(45))
            } else {
                XCTFail("Expected rotate as second parallel step")
            }
        } else {
            XCTFail("Expected parallelGroup step")
        }
    }
    
    func testAnimationState() {
        // Test animation state initialization
        let state = AnimationState()
        
        XCTAssertEqual(state.opacity, 1.0)
        XCTAssertEqual(state.scale, 1.0)
        XCTAssertEqual(state.offset, .zero)
        XCTAssertEqual(state.rotation, .zero)
    }
    
    func testAnimationBuilderExtensions() {
        // Test extension methods
        let view = Circle()
        let builder = view
            .mithril()
            .fadeIn(duration: 0.5)
            .then()
            .scaleUp(to: 1.2, duration: 0.3)
            .then()
            .rotate(degrees: 180, duration: 0.4)
            .then()
            .pulse(scale: 1.1, duration: 0.2)
        
        XCTAssertNotNil(builder)
    }
    
    func testConvenienceMethods() {
        // Test convenience animation methods
        let view = Text("Test")
        
        let quickBounce = view.mithril().quickBounce()
        let heartbeat = view.mithril().heartbeat()
        let rubberBand = view.mithril().rubberBand()
        let tada = view.mithril().tada()
        
        XCTAssertNotNil(quickBounce)
        XCTAssertNotNil(heartbeat)
        XCTAssertNotNil(rubberBand)
        XCTAssertNotNil(tada)
    }
    
    func testComplexAnimationSequence() {
        // Test complex animation sequence
        let view = RoundedRectangle(cornerRadius: 12)
        let complexAnimation = view
            .mithril()
            .fadeIn(duration: 0.3)
            .then()
            .scaleUp(to: 1.2, duration: 0.2)
            .and()
            .rotate(degrees: 45, duration: 0.2)
            .then()
            .delay(0.5)
            .then()
            .shake(.horizontal, intensity: 10, duration: 0.6)
            .then()
            .spring(.bouncy, duration: 0.8)
            .then()
            .fadeOut(duration: 0.3)
        
        XCTAssertNotNil(complexAnimation)
    }
    
    func testPresetWithView() {
        // Test applying preset to view
        let view = Image(systemName: "heart.fill")
        let animatedView = view.mithril(.socialLike)
        
        XCTAssertNotNil(animatedView)
    }
}
