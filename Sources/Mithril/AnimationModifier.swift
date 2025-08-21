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
    
    private func applyAnimationStep(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case .fadeIn, .fadeOut, .fadeTo:
            applyFadeAnimation(step, completion: completion)
        case .scaleUp, .scaleDown, .scaleFrom:
            applyScaleAnimation(step, completion: completion)
        case .moveTo, .moveBy:
            applyMoveAnimation(step, completion: completion)
        case .rotate, .spin:
            applyRotationAnimation(step, completion: completion)
        case .slideIn, .slideOut:
            applySlideAnimation(step, completion: completion)
        default:
            applySpecialAnimationStep(step, completion: completion)
        }
    }
    private func applySpecialAnimationStep(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case let .spring(type, duration):
            applySpringAnimation(type: type, duration: duration, completion: completion)
        case let .shake(direction, intensity, duration):
            executeShakeAnimation(
                direction: direction,
                intensity: intensity,
                duration: duration,
                completion: completion
            )
        case let .pulse(scale, duration):
            applyPulseAnimation(scale: scale, duration: duration, completion: completion)
        case .delay(let duration):
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
        case .loop(let mode):
            handleRepeat(mode: mode, completion: completion)
        case .custom:
            completion()
        case .parallelGroup(let parallelSteps):
            executeParallelSteps(parallelSteps, completion: completion)
        default:
            assertionFailure("Unhandled AnimationStep type in applySpecialAnimationStep: \(step)")
            completion()
        }
    }
    private func applyFadeAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case .fadeIn(let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = 1.0
            }
        case .fadeOut(let duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = 0.0
            }
        case let .fadeTo(opacity, duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.opacity = opacity
            }
        default:
            assertionFailure("Unhandled AnimationStep type in applyFadeAnimation: \(step)")
        }
        
        let duration = extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    private func applyScaleAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case let .scaleUp(scale, duration), let .scaleDown(scale, duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.scale = scale
            }
        case let .scaleFrom(from, to, duration):
            animationState.scale = from
            withAnimation(.easeInOut(duration: duration)) {
                animationState.scale = to
            }
        default:
            assertionFailure("Unhandled AnimationStep type in applyScaleAnimation: \(step)")
        }
        
        let duration = self.extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }

    private func applySlideAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case let .slideIn(direction, distance, duration):
            let initialOffset = offsetForSlideDirection(direction, distance: distance)
            animationState.offset = initialOffset
            withAnimation(.easeOut(duration: duration)) {
                animationState.offset = .zero
            }
        case let .slideOut(direction, distance, duration):
            let finalOffset = offsetForSlideDirection(direction, distance: distance)
            withAnimation(.easeIn(duration: duration)) {
                animationState.offset = finalOffset
            }
        default:
            assertionFailure("Unhandled AnimationStep type in applySlideAnimation: \(step)")
        }
        
        let duration = extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
}

private extension AnimationModifier {
    private func applyMoveAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case let .moveTo(x, y, duration):
            withAnimation(.easeInOut(duration: duration)) {
                animationState.offset = CGSize(width: x, height: y)
            }
        case let .moveBy(x, y, duration):
            let newOffset = CGSize(
                width: animationState.offset.width + x,
                height: animationState.offset.height + y
            )
            if duration == 0 {
                animationState.offset = newOffset
                completion()
                return
            } else {
                withAnimation(.easeInOut(duration: duration)) {
                    animationState.offset = newOffset
                }
            }
        default:
            assertionFailure("Unhandled AnimationStep type in applyMoveAnimation: \(step)")
        }
        
        let duration = extractDuration(from: step)
        // Only schedule completion if duration > 0 to avoid duplicate calls
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
        } else {
            completion()
        }
    }
    
    private func applyRotationAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
        switch step {
        case let .rotate(angle, duration):
            if duration == 0 {
                animationState.rotation = angle
                completion()
                return
            } else {
                withAnimation(.easeInOut(duration: duration)) {
                    animationState.rotation = angle
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
            return
        default:
            assertionFailure("Unhandled AnimationStep type in applyRotationAnimation: \(step)")
        }
        
        let duration = extractDuration(from: step)
        // Only schedule completion if duration > 0 to avoid duplicate calls
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion()
            }
        } else {
            completion()
        }
    }
    
    private func applySpringAnimation(type: SpringType, duration: TimeInterval, completion: @escaping () -> Void) {
        withAnimation(type.animation) {
            animationState.scale = 1.1
        }
        withAnimation(type.animation.delay(duration * 0.5)) {
            animationState.scale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    private func applyPulseAnimation(scale: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: duration / 2).repeatCount(2, autoreverses: true)) {
            animationState.scale = scale
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    private func handleRepeat(mode: RepeatMode, completion: @escaping () -> Void) {
        switch mode {
        case .once:
            completion()
        case .forever:
            handleForeverRepeat()
        case .times(let count):
            handleTimesRepeat(count: count, completion: completion)
        case .duration(let duration):
            handleDurationRepeat(duration: duration, completion: completion)
        case .until(let condition):
            handleConditionalRepeat(condition: condition, completion: completion)
        }
    }
    
    private func handleForeverRepeat() {
        resetAnimationState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.executeAnimations()
        }
    }
    
    private func handleTimesRepeat(count: Int, completion: @escaping () -> Void) {
        if repeatCount < count {
            repeatCount += 1
            resetAnimationState()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.executeAnimations()
            }
        } else {
            repeatCount = 0
            completion()
        }
    }
    
    private func handleDurationRepeat(duration: TimeInterval, completion: @escaping () -> Void) {
        let now = Date()
        if repeatStartTime == nil {
            repeatStartTime = now
        }
        
        guard let startTime = repeatStartTime else {
            repeatStartTime = now
            resetAnimationState()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.executeAnimations()
            }
            return
        }
        
        let elapsed = now.timeIntervalSince(startTime)
        if elapsed < duration {
            resetAnimationState()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.executeAnimations()
            }
        } else {
            repeatStartTime = nil
            completion()
        }
    }
    
    private func handleConditionalRepeat(condition: @escaping () -> Bool, completion: @escaping () -> Void) {
        if !condition() {
            resetAnimationState()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.executeAnimations()
            }
        } else {
            completion()
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
}
