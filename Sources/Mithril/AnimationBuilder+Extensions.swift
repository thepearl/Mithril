//
//  AnimationBuilder+Extensions.swift
//  Mithril - SwiftUI Animation Studio
//
//  Extension methods for AnimationBuilder to provide fluent API
//

import SwiftUI

// MARK: - Basic Transform Animations

extension AnimationBuilder {
    
    // MARK: - Scale Animations
    
    /// Scale up to specified value
    public func scaleUp(to scale: CGFloat = 1.2, duration: TimeInterval = 0.3) -> Self {
        return addStep(.scaleUp(to: scale, duration: duration))
    }
    
    /// Scale down to specified value
    public func scaleDown(to scale: CGFloat = 0.8, duration: TimeInterval = 0.3) -> Self {
        return addStep(.scaleDown(to: scale, duration: duration))
    }
    
    /// Scale from one value to another
    public func scaleFrom(_ from: CGFloat, to: CGFloat, duration: TimeInterval = 0.3) -> Self {
        return addStep(.scaleFrom(from: from, to: to, duration: duration))
    }
    
    // MARK: - Fade Animations
    
    /// Fade in to full opacity
    public func fadeIn(duration: TimeInterval = 0.3) -> Self {
        return addStep(.fadeIn(duration: duration))
    }
    
    /// Fade out to zero opacity
    public func fadeOut(duration: TimeInterval = 0.3) -> Self {
        return addStep(.fadeOut(duration: duration))
    }
    
    /// Fade to specific opacity value
    public func fadeTo(_ opacity: Double, duration: TimeInterval = 0.3) -> Self {
        return addStep(.fadeTo(opacity: opacity, duration: duration))
    }
    
    // MARK: - Movement Animations
    
    /// Move to absolute position
    public func moveTo(x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 0.3) -> Self {
        return addStep(.moveTo(x: x, y: y, duration: duration))
    }
    
    /// Move by relative amount
    public func moveBy(x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 0.3) -> Self {
        return addStep(.moveBy(x: x, y: y, duration: duration))
    }
    
    // MARK: - Rotation Animations
    
    /// Rotate to specific angle
    public func rotate(_ angle: Angle, duration: TimeInterval = 0.3) -> Self {
        return addStep(.rotate(angle: angle, duration: duration))
    }
    
    /// Rotate by degrees
    public func rotate(degrees: Double, duration: TimeInterval = 0.3) -> Self {
        return addStep(.rotate(angle: .degrees(degrees), duration: duration))
    }
    
    /// Rotate by radians
    public func rotate(radians: Double, duration: TimeInterval = 0.3) -> Self {
        return addStep(.rotate(angle: .radians(radians), duration: duration))
    }
    
    /// Spin 360 degrees
    public func spin(duration: TimeInterval = 1.0) -> Self {
        return addStep(.spin(duration: duration))
    }
    
    // MARK: - Slide Animations
    
    /// Slide in from specified direction
    public func slideIn(_ direction: SlideDirection, distance: CGFloat = 300, duration: TimeInterval = 0.5) -> Self {
        return addStep(.slideIn(direction: direction, distance: distance, duration: duration))
    }
    
    /// Slide out in specified direction
    public func slideOut(_ direction: SlideDirection, distance: CGFloat = 300, duration: TimeInterval = 0.5) -> Self {
        return addStep(.slideOut(direction: direction, distance: distance, duration: duration))
    }
    
    // MARK: - Spring Physics
    
    /// Apply spring animation
    public func spring(_ type: SpringType = .smooth, duration: TimeInterval = 0.6) -> Self {
        return addStep(.spring(type: type, duration: duration))
    }
    
    /// Elastic spring effect
    public func elastic(duration: TimeInterval = 0.8) -> Self {
        return addStep(.spring(type: .bouncy, duration: duration))
    }
    
    /// Bouncy spring effect
    public func bounce(duration: TimeInterval = 0.6) -> Self {
        return addStep(.spring(type: .bouncy, duration: duration))
    }
    
    // MARK: - Attention Effects
    
    /// Shake animation
    public func shake(_ direction: ShakeDirection = .horizontal, intensity: CGFloat = 10, duration: TimeInterval = 0.6) -> Self {
        return addStep(.shake(direction: direction, intensity: intensity, duration: duration))
    }
    
    /// Pulse scale effect
    public func pulse(scale: CGFloat = 1.1, duration: TimeInterval = 0.5) -> Self {
        return addStep(.pulse(scale: scale, duration: duration))
    }
    
    /// Flash opacity effect
    public func flash(duration: TimeInterval = 0.4) -> Self {
        return self
            .fadeTo(0.3, duration: duration / 4)
            .then()
            .fadeTo(1.0, duration: duration / 4)
            .then()
            .fadeTo(0.3, duration: duration / 4)
            .then()
            .fadeTo(1.0, duration: duration / 4)
    }
    
    /// Wiggle rotation effect
    public func wiggle(duration: TimeInterval = 0.5) -> Self {
        return self
            .rotate(degrees: -5, duration: duration / 5)
            .then()
            .rotate(degrees: 5, duration: duration / 5)
            .then()
            .rotate(degrees: -3, duration: duration / 5)
            .then()
            .rotate(degrees: 3, duration: duration / 5)
            .then()
            .rotate(degrees: 0, duration: duration / 5)
    }
}

// MARK: - Convenience Methods

extension AnimationBuilder {
    
    /// Quick bounce attention effect
    public func quickBounce() -> Self {
        return self
            .scaleUp(to: 1.1, duration: 0.1)
            .then()
            .scaleDown(to: 1.0, duration: 0.1)
    }
    
    /// Heartbeat effect
    public func heartbeat() -> Self {
        return self
            .scaleUp(to: 1.3, duration: 0.1)
            .then()
            .scaleDown(to: 1.0, duration: 0.1)
            .then()
            .delay(0.1)
            .then()
            .scaleUp(to: 1.3, duration: 0.1)
            .then()
            .scaleDown(to: 1.0, duration: 0.1)
    }
    
    /// Rubber band effect
    public func rubberBand() -> Self {
        return self
            .scaleUp(to: 1.25, duration: 0.1)
            .then()
            .scaleDown(to: 0.75, duration: 0.1)
            .then()
            .scaleUp(to: 1.15, duration: 0.1)
            .then()
            .scaleDown(to: 1.0, duration: 0.1)
    }
    
    /// Tada celebration effect
    public func tada() -> Self {
        return self
            .scaleUp(to: 0.9, duration: 0.1)
            .and()
            .rotate(degrees: -3, duration: 0.1)
            .then()
            .scaleUp(to: 1.1, duration: 0.1)
            .and()
            .rotate(degrees: 3, duration: 0.1)
            .then()
            .scaleDown(to: 1.0, duration: 0.1)
            .and()
            .rotate(degrees: 0, duration: 0.1)
    }
}

// MARK: - Helper Methods

extension AnimationBuilder {
    
    /// Add a custom animation step
    public func custom(_ transform: @escaping (any View) -> any View) -> Self {
        return addStep(AnimationStep.custom(transform))
    }
    
}