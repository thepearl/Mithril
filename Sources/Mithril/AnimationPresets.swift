//
//  AnimationPresets.swift
//  Mithril - SwiftUI Animation Studio
//
//  Predefined animation sequences for common use cases
//

import SwiftUI

// MARK: - Animation Preset

/// Predefined animation sequences
public struct AnimationPreset {
    internal let steps: [AnimationStep]
    
    internal init(steps: [AnimationStep]) {
        self.steps = steps
    }
    
    /// Create custom preset from animation steps
    public static func custom(_ steps: [AnimationStep]) -> AnimationPreset {
        return AnimationPreset(steps: steps)
    }
}

// MARK: - Entrance Animations

extension AnimationPreset {
    /// Fade in from bottom with slight scale
    public static let fadeInUp = AnimationPreset(steps: [
        .moveBy(x: 0, y: 50, duration: 0),
        .fadeTo(opacity: 0, duration: 0),
        .scaleFrom(from: 0.9, to: 1.0, duration: 0.6),
        .fadeTo(opacity: 1.0, duration: 0.6),
        .moveBy(x: 0, y: -50, duration: 0.6)
    ])
    
    /// Slide in from left
    public static let slideInLeft = AnimationPreset(steps: [
        .slideIn(direction: .left, distance: 300, duration: 0.5)
    ])
    
    /// Zoom in with bounce
    public static let zoomIn = AnimationPreset(steps: [
        .scaleFrom(from: 0.0, to: 1.1, duration: 0.3),
        .scaleFrom(from: 1.1, to: 1.0, duration: 0.2)
    ])
    
    /// Bounce entrance
    public static let bounceIn = AnimationPreset(steps: [
        .scaleFrom(from: 0.3, to: 1.05, duration: 0.3),
        .scaleFrom(from: 1.05, to: 0.9, duration: 0.1),
        .scaleFrom(from: 0.9, to: 1.0, duration: 0.1)
    ])
    
    /// Rotate in
    public static let rotateIn = AnimationPreset(steps: [
        .rotate(angle: .degrees(-180), duration: 0),
        .fadeTo(opacity: 0, duration: 0),
        .rotate(angle: .degrees(0), duration: 0.6),
        .fadeTo(opacity: 1.0, duration: 0.6)
    ])
}

// MARK: - Exit Animations

extension AnimationPreset {
    /// Fade out to bottom
    public static let fadeOutDown = AnimationPreset(steps: [
        .fadeTo(opacity: 0, duration: 0.5),
        .moveBy(x: 0, y: 50, duration: 0.5),
        .scaleFrom(from: 1.0, to: 0.9, duration: 0.5)
    ])
    
    /// Slide out to right
    public static let slideOutRight = AnimationPreset(steps: [
        .slideOut(direction: .right, distance: 300, duration: 0.5)
    ])
    
    /// Zoom out
    public static let zoomOut = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 0.0, duration: 0.4),
        .fadeTo(opacity: 0, duration: 0.4)
    ])
}

// MARK: - Attention Animations

extension AnimationPreset {
    /// Bounce attention grabber
    public static let bounce = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 1.1, duration: 0.2),
        .scaleFrom(from: 1.1, to: 1.0, duration: 0.2)
    ])
    
    /// Flash opacity
    public static let flash = AnimationPreset(steps: [
        .fadeTo(opacity: 0.3, duration: 0.1),
        .fadeTo(opacity: 1.0, duration: 0.1),
        .fadeTo(opacity: 0.3, duration: 0.1),
        .fadeTo(opacity: 1.0, duration: 0.1)
    ])
    
    /// Pulse scale
    public static let pulse = AnimationPreset(steps: [
        .pulse(scale: 1.1, duration: 0.5)
    ])
    
    /// Shake horizontally
    public static let shake = AnimationPreset(steps: [
        .shake(direction: .horizontal, intensity: 10, duration: 0.6)
    ])
    
    /// Wobble rotation
    public static let wobble = AnimationPreset(steps: [
        .rotate(angle: .degrees(-5), duration: 0.1),
        .rotate(angle: .degrees(5), duration: 0.1),
        .rotate(angle: .degrees(-3), duration: 0.1),
        .rotate(angle: .degrees(3), duration: 0.1),
        .rotate(angle: .degrees(0), duration: 0.1)
    ])
    
    /// Heartbeat pulse
    public static let heartbeat = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 1.3, duration: 0.1),
        .scaleFrom(from: 1.3, to: 1.0, duration: 0.1),
        .delay(0.1),
        .scaleFrom(from: 1.0, to: 1.3, duration: 0.1),
        .scaleFrom(from: 1.3, to: 1.0, duration: 0.1)
    ])
}

// MARK: - Complex Sequences

extension AnimationPreset {
    /// Card flip animation
    public static let cardFlip = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 0.0, duration: 0.3),
        .scaleFrom(from: 0.0, to: 1.0, duration: 0.3)
    ])
    
    /// Button press feedback
    public static let buttonPress = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 0.95, duration: 0.1),
        .scaleFrom(from: 0.95, to: 1.0, duration: 0.1)
    ])
    
    /// Social media like animation
    public static let socialLike = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 1.3, duration: 0.2),
        .scaleFrom(from: 1.3, to: 1.0, duration: 0.2)
    ])
    
    /// Add to cart animation
    public static let addToCart = AnimationPreset(steps: [
        .scaleFrom(from: 1.0, to: 0.8, duration: 0.1),
        .scaleFrom(from: 0.8, to: 1.1, duration: 0.2),
        .scaleFrom(from: 1.1, to: 1.0, duration: 0.1)
    ])
    
    /// List item entrance
    public static let listItem = AnimationPreset(steps: [
        .slideIn(direction: .left, distance: 50, duration: 0.3),
        .fadeTo(opacity: 1.0, duration: 0.3)
    ])
}