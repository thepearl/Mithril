//
//  AnimationState.swift
//  Mithril - SwiftUI Animation Studio
//
//  Animation state management and modifiers
//

import SwiftUI

// MARK: - Animation State

/// Holds the current state of all animation properties
class AnimationState: ObservableObject {
    @Published var opacity: Double = 1.0
    @Published var scale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var rotation: Angle = .zero
}

// MARK: - Animation State Modifier

/// ViewModifier that applies animation state to a view
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
