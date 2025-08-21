//
//  AnimationUtilities.swift
//  Mithril - SwiftUI Animation Studio
//
//  Animation utility functions and helpers
//

import SwiftUI

// MARK: - Animation Utilities

extension AnimationModifier {
    /// Extracts duration from an animation step
    func extractDuration(from step: AnimationStep) -> TimeInterval {
        return extractBasicDuration(from: step) ?? extractAdvancedDuration(from: step)
    }
    
    private func extractBasicDuration(from step: AnimationStep) -> TimeInterval? {
        switch step {
        case let .fadeIn(duration), let .fadeOut(duration), let .fadeTo(_, duration):
            return duration
        case let .scaleUp(_, duration), let .scaleDown(_, duration), let .scaleFrom(_, _, duration):
            return duration
        case let .moveTo(_, _, duration), let .moveBy(_, _, duration):
            return duration
        case let .rotate(_, duration), let .spin(duration):
            return duration
        case let .slideIn(_, _, duration), let .slideOut(_, _, duration):
            return duration
        default:
            return nil
        }
    }
    
    private func extractAdvancedDuration(from step: AnimationStep) -> TimeInterval {
        switch step {
        case let .spring(_, duration):
            return duration
        case let .shake(_, _, duration):
            return duration
        case let .pulse(_, duration):
            return duration
        case let .delay(duration):
            return duration
        case .loop, .custom, .parallelGroup:
            return 0
        default:
            return 0
        }
    }
    
    /// Calculates offset for slide direction
    func offsetForSlideDirection(_ direction: SlideDirection, distance: CGFloat) -> CGSize {
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
}
