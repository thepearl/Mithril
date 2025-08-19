//
//  Mithril.swift
//  Mithril - SwiftUI Animation Studio
//
//  A declarative, chainable animation library for SwiftUI
//

import SwiftUI

// MARK: - Core Protocol

/// Protocol that enables any View to use Mithril animations
public protocol Animatable: View {
    /// Start an animation chain with optional preset
    func mithril(_ preset: AnimationPreset?) -> AnimationBuilder<Self>
    /// Start an animation chain without preset
    func mithril() -> AnimationBuilder<Self>
}

// MARK: - View Extension

extension View {
    public func mithril(_ preset: AnimationPreset? = nil) -> AnimationBuilder<Self> {
        return AnimationBuilder(content: self, preset: preset)
    }
    
    public func mithril() -> AnimationBuilder<Self> {
        return AnimationBuilder(content: self, preset: nil)
    }
}

// MARK: - Animation Builder

/// Main builder class for chaining animations
public struct AnimationBuilder<Content: View> {
    internal let content: Content
    internal var steps: [AnimationStep]
    internal var currentGroup: AnimationGroup
    
    internal init(content: Content, preset: AnimationPreset? = nil) {
        self.content = content
        self.steps = []
        self.currentGroup = .sequential
        
        // Apply preset if provided
        if let preset = preset {
            self.steps = preset.steps
        }
    }
    
    internal init(content: Content, steps: [AnimationStep], currentGroup: AnimationGroup) {
        self.content = content
        self.steps = steps
        self.currentGroup = currentGroup
    }
}

// MARK: - Animation Sequencing

extension AnimationBuilder {
    /// Execute next animation after current one completes
    public func then() -> Self {
        return AnimationBuilder(content: content, steps: steps, currentGroup: .sequential)
    }
    
    /// Execute next animation in parallel with current one
    public func and() -> Self {
        return AnimationBuilder(content: content, steps: steps, currentGroup: .parallel)
    }
    
    /// Add delay before next animation
    public func delay(_ duration: TimeInterval) -> Self {
        let delayStep = AnimationStep.delay(duration)
        return addStep(delayStep)
    }
    
    /// Repeat animation with specified mode
    public func loop(_ mode: RepeatMode) -> Self {
        let repeatStep = AnimationStep.loop(mode)
        return addStep(repeatStep)
    }
    
    internal func addStep(_ step: AnimationStep) -> Self {
        var newSteps = steps
        
        if currentGroup == .parallel && !newSteps.isEmpty {
            // Check if the last step is already a parallel group
            if case .parallelGroup(var parallelSteps) = newSteps.last {
                // Add to existing parallel group
                parallelSteps.append(step)
                newSteps[newSteps.count - 1] = .parallelGroup(parallelSteps)
            } else {
                // Create new parallel group with last step and current step
                let lastStep = newSteps.removeLast()
                newSteps.append(.parallelGroup([lastStep, step]))
            }
        } else {
            // Sequential execution - just append
            newSteps.append(step)
        }
        
        return AnimationBuilder(content: content, steps: newSteps, currentGroup: currentGroup)
    }
}

// MARK: - View Conformance

extension AnimationBuilder: View {
    public var body: some View {
        content
            .modifier(AnimationModifier(steps: steps))
    }
}

// MARK: - Supporting Types

/// Defines how animations are grouped
public enum AnimationGroup {
    case sequential
    case parallel
}

/// Defines repeat behavior for animations
public enum RepeatMode {
    case once
    case forever
    case times(Int)
    case duration(TimeInterval)
    case until(() -> Bool)
}

/// Individual animation step
public enum AnimationStep {
    case fadeIn(duration: TimeInterval)
    case fadeOut(duration: TimeInterval)
    case fadeTo(opacity: Double, duration: TimeInterval)
    case scaleUp(to: CGFloat, duration: TimeInterval)
    case scaleDown(to: CGFloat, duration: TimeInterval)
    case scaleFrom(from: CGFloat, to: CGFloat, duration: TimeInterval)
    case moveTo(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case moveBy(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case rotate(angle: Angle, duration: TimeInterval)
    case spin(duration: TimeInterval)
    case slideIn(direction: SlideDirection, distance: CGFloat, duration: TimeInterval)
    case slideOut(direction: SlideDirection, distance: CGFloat, duration: TimeInterval)
    case spring(type: SpringType, duration: TimeInterval)
    case shake(direction: ShakeDirection, intensity: CGFloat, duration: TimeInterval)
    case pulse(scale: CGFloat, duration: TimeInterval)
    case delay(TimeInterval)
    case loop(RepeatMode)
    case custom((any View) -> any View)
    case parallelGroup([AnimationStep])
}

/// Direction for slide animations
public enum SlideDirection {
    case up, down, left, right
    case topLeading, topTrailing, bottomLeading, bottomTrailing
}

/// Direction for shake animations
public enum ShakeDirection {
    case horizontal, vertical, both
}

/// Spring animation types
public enum SpringType {
    case smooth
    case snappy
    case bouncy
    case wobbly
    case custom(tension: Double, friction: Double)
    
    var animation: Animation {
        switch self {
        case .smooth:
            return .spring(response: 0.6, dampingFraction: 0.8)
        case .snappy:
            return .spring(response: 0.3, dampingFraction: 0.7)
        case .bouncy:
            return .spring(response: 0.5, dampingFraction: 0.5)
        case .wobbly:
            return .spring(response: 0.8, dampingFraction: 0.3)
        case .custom(let tension, let friction):
            return .spring(response: tension, dampingFraction: friction)
        }
    }
}
