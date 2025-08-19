//
//  AnimationModifier.swift
//  Mithril - SwiftUI Animation Studio
//
//  Core animation modifier that executes animation steps
//

import SwiftUI

// MARK: - Animation Modifier

/// ViewModifier that applies animation steps to a view
struct AnimationModifier: ViewModifier {
    let steps: [AnimationStep]
    
    @State private var currentStepIndex = 0
    @State private var isAnimating = false
    @State private var animationState = AnimationState()
    @State private var repeatCount = 0
    @State private var repeatStartTime: Date?
    
    func body(content: Content) -> some View {
        content
            .modifier(AnimationStateModifier(state: animationState))
            .onAppear {
                executeAnimations()
            }
    }
    
    private func executeAnimations() {
        guard !steps.isEmpty else { return }
        isAnimating = true
        executeStep(at: 0)
    }
    
    private func executeStep(at index: Int) {
        guard index < steps.count else {
            isAnimating = false
            return
        }
        
        let step = steps[index]
        applyAnimationStep(step) {
            executeStep(at: index + 1)
        }
    }
    
    private func applyAnimationStep(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case .fadeIn(let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .fadeOut(let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .fadeTo(let opacity, let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = opacity
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .scaleUp(let scale, let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.scale = scale
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .scaleDown(let scale, let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.scale = scale
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .scaleFrom(let from, let to, let duration):
            animationState.scale = from
            withAnimation(.easeInOut(duration: duration)) {
                animationState.scale = to
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .moveTo(let x, let y, let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.offset = CGSize(width: x, height: y)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .moveBy(let x, let y, let duration):
            let newOffset = CGSize(
                width: animationState.offset.width + x,
                height: animationState.offset.height + y
            )
            if duration == 0 {
                animationState.offset = newOffset
                completion()
            } else {
                withAnimation(.easeInOut(duration: duration)) {
                    animationState.offset = newOffset
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    completion()
                }
            }
            
        case .rotate(let angle, let duration):
            if duration == 0 {
                animationState.rotation = angle
                completion()
            } else {
                withAnimation(.easeInOut(duration: duration)) {
                    animationState.rotation = angle
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    completion()
                }
            }
            
        case .spin(let duration):
            withAnimation(.linear(duration: duration)) {
                animationState.rotation = .degrees(360)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                animationState.rotation = .degrees(0)
                completion()
            }
            
        case .slideIn(let direction, let distance, let duration):
            let initialOffset = offsetForSlideDirection(direction, distance: distance)
            animationState.offset = initialOffset
            withAnimation(.easeOut(duration: duration)) {
                animationState.offset = .zero
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .slideOut(let direction, let distance, let duration):
            let finalOffset = offsetForSlideDirection(direction, distance: distance)
            withAnimation(.easeIn(duration: duration)) {
                animationState.offset = finalOffset
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .spring(let type, let duration):
            withAnimation(type.animation) {
                animationState.scale = 1.1
            }
            withAnimation(type.animation.delay(duration * 0.5)) {
                animationState.scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .shake(let direction, let intensity, let duration):
            executeShakeAnimation(direction: direction, intensity: intensity, duration: duration, completion: completion)
            
        case .pulse(let scale, let duration):
            withAnimation(.easeInOut(duration: duration / 2).repeatCount(2, autoreverses: true)) {
                animationState.scale = scale
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .delay(let duration):
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
            
        case .loop(let mode):
            handleRepeat(mode: mode, completion: completion)
            
        case .custom(let transform):
            // Apply custom transformation to the view
            // The transform function should handle its own animation timing
            // and will be applied through the AnimationBuilder's custom method
            completion()
            
        case .parallelGroup(let parallelSteps):
            executeParallelSteps(parallelSteps, completion: completion)
        }
    }
    
    private func offsetForSlideDirection(_ direction: SlideDirection, distance: CGFloat) -> CGSize {
        switch direction {
        case .up:
            return CGSize(width: 0, height: -distance)
        case .down:
            return CGSize(width: 0, height: distance)
        case .left:
            return CGSize(width: -distance, height: 0)
        case .right:
            return CGSize(width: distance, height: 0)
        case .topLeading:
            return CGSize(width: -distance, height: -distance)
        case .topTrailing:
            return CGSize(width: distance, height: -distance)
        case .bottomLeading:
            return CGSize(width: -distance, height: distance)
        case .bottomTrailing:
            return CGSize(width: distance, height: distance)
        }
    }
    
    private func handleRepeat(mode: RepeatMode, completion: @escaping () -> Void) {
        switch mode {
        case .once:
            completion()
            
        case .forever:
            // Reset animation state and restart from beginning
            resetAnimationState()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.executeAnimations()
            }
            
        case .times(let count):
            // Implement times repeat - track how many times we've repeated
            if repeatCount < count {
                repeatCount += 1
                // Reset animation state and restart
                resetAnimationState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.executeAnimations()
                }
            } else {
                // Reset counter and complete
                repeatCount = 0
                completion()
            }
            
        case .duration(let duration):
            // Implement duration repeat - repeat for a specific time duration
            let now = Date()
            if repeatStartTime == nil {
                repeatStartTime = now
            }
            
            let elapsed = now.timeIntervalSince(repeatStartTime!)
            if elapsed < duration {
                // Reset animation state and restart
                resetAnimationState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.executeAnimations()
                }
            } else {
                // Reset start time and complete
                repeatStartTime = nil
                completion()
            }
            
        case .until(let condition):
            // Implement conditional repeat - repeat until condition is met
            if !condition() {
                // Condition not met, continue repeating
                resetAnimationState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.executeAnimations()
                }
            } else {
                // Condition met, complete the animation
                completion()
            }
        }
    }
    
    private func resetAnimationState() {
        animationState.opacity = 1.0
        animationState.scale = 1.0
        animationState.offset = .zero
        animationState.rotation = .zero
    }
    
    private func executeParallelSteps(_ steps: [AnimationStep], completion: @escaping () -> Void) {
        guard !steps.isEmpty else {
            completion()
            return
        }
        
        let group = DispatchGroup()
        
        for step in steps {
            group.enter()
            applyAnimationStep(step) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func executeShakeAnimation(direction: ShakeDirection, intensity: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
        let steps = 8
        let stepDuration = duration / Double(steps)
        
        func shakeStep(_ step: Int) {
            guard step < steps else {
                animationState.offset = .zero
                completion()
                return
            }
            
            let progress = Double(step) / Double(steps)
            let amplitude = intensity * (1.0 - progress) // Decay over time
            let randomX = direction == .vertical ? 0 : CGFloat.random(in: -amplitude...amplitude)
            let randomY = direction == .horizontal ? 0 : CGFloat.random(in: -amplitude...amplitude)
            
            withAnimation(.easeInOut(duration: stepDuration)) {
                animationState.offset = CGSize(width: randomX, height: randomY)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration) {
                shakeStep(step + 1)
            }
        }
        
        shakeStep(0)
    }
}

// MARK: - Animation State

/// Holds the current state of all animation properties
class AnimationState: ObservableObject {
    @Published var opacity: Double = 1.0
    @Published var scale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var rotation: Angle = .zero
}

// MARK: - Animation State Modifier

/// Applies the animation state to a view
struct AnimationStateModifier: ViewModifier {
    @ObservedObject var state: AnimationState
    
    func body(content: Content) -> some View {
        content
            .opacity(state.opacity)
            .scaleEffect(state.scale)
            .offset(state.offset)
            .rotationEffect(state.rotation)
    }
}
