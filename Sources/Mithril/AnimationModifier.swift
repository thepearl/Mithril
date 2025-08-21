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
            break
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
            break
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
            break
        }
        
        let duration = extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
}

private extension AnimationModifier {
    func applyMoveAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
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
            break
        }
        
        let duration = extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    func applyRotationAnimation(_ step: AnimationStep, completion: @escaping () -> Void) {
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
            break
        }
        
        let duration = extractDuration(from: step)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    func applySpringAnimation(type: SpringType, duration: TimeInterval, completion: @escaping () -> Void) {
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
    
    func applyPulseAnimation(scale: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: duration / 2).repeatCount(2, autoreverses: true)) {
            animationState.scale = scale
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    func handleRepeat(mode: RepeatMode, completion: @escaping () -> Void) {
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
            let elapsed = now.timeIntervalSince(repeatStartTime ?? now)
            if elapsed < duration {
                // Reset animation state and restart
                resetAnimationState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.executeAnimations()
                }
            } else {
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
    
    func resetAnimationState() {
        animationState.opacity = 1.0
        animationState.scale = 1.0
        animationState.offset = .zero
        animationState.rotation = .zero
    }
    
    func executeParallelSteps(_ steps: [AnimationStep], completion: @escaping () -> Void) {
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
    func executeShakeAnimation(direction: ShakeDirection, intensity: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
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
    
    func executeAnimations() {
        guard !steps.isEmpty else { return }
        isAnimating = true
        executeStep(at: 0)
    }
    
    func executeStep(at index: Int) {
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
