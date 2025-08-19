//
//  Demo.swift
//  Mithril - SwiftUI Animation Studio
//
//  Demo animations to test the architecture
//

import SwiftUI

#if DEBUG

// MARK: - Demo View

/// Demo view showcasing various Mithril animations
public struct MithrilDemo: View {
    @State private var showDemo = false
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Mithril Animation Studio")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .mithril(.fadeInUp)

                Text("Tap any element to see animations")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .mithril(.fadeInUp)
                    .delay(0.2)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                    // Demo 1: Basic Fade and Scale
                    DemoCard(title: "Fade & Scale", color: .blue) {
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                            .mithril()
                            .fadeOut(duration: 0.3)
                            .then()
                            .scaleUp(to: 1.5, duration: 0.3)
                            .then()
                            .fadeIn(duration: 0.3)
                            .then()
                            .scaleDown(to: 1.0, duration: 0.3)
                            .loop(.forever)
                    }
                    
                    // Demo 2: Bounce Preset
                    DemoCard(title: "Bounce", color: .green) {
                        Circle()
                            .fill(.green)
                            .frame(width: 60, height: 60)
                            .mithril(.bounce)
                            .loop(.forever)
                    }
                    
                    // Demo 3: Slide Animation
                    DemoCard(title: "Slide In", color: .orange) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.orange)
                            .frame(width: 60, height: 60)
                            .mithril()
                            .slideOut(.left, distance: 100, duration: 0.3)
                            .then()
                            .slideIn(.right, distance: 100, duration: 0.8)
                            .loop(.forever)
                    }
                    
                    // Demo 4: Rotation and Spin
                    DemoCard(title: "Spin", color: .purple) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                            .mithril()
                            .spin(duration: 3)
                            .loop(.forever)
                    }
                    
                    // Demo 5: Shake Animation
                    DemoCard(title: "Shake", color: .red) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.red)
                            .frame(width: 60, height: 60)
                            .mithril()
                            .shake(.horizontal, intensity: 15, duration: 0.6)
                            .loop(.forever)
                    }
                    
                    // Demo 6: Pulse Effect
                    DemoCard(title: "Pulse", color: .pink) {
                        Heart()
                            .fill(.pink)
                            .frame(width: 50, height: 50)
                            .mithril()
                            .pulse(scale: 1.3, duration: 1)
                            .loop(.forever)
                    }
                    
                    // Demo 7: Complex Sequence
                    DemoCard(title: "Complex", color: .cyan) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.cyan)
                            .frame(width: 60, height: 60)
                            .mithril()
                            .scaleDown(to: 0.8, duration: 0.2)
                            .then()
                            .rotate(degrees: 180, duration: 0.4)
                            .and()
                            .scaleUp(to: 1.2, duration: 0.4)
                            .and()
                            .wiggle()
                            .then()
                            .rotate(degrees: 360, duration: 0.4)
                            .and()
                            .scaleDown(to: 1.0, duration: 0.4)
                            .loop(.forever)
                    }
                    
                    // Demo 8: Social Like Animation
                    DemoCard(title: "Like", color: .red) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .mithril(.socialLike)
                            .loop(.forever)
                    }
                    
                    // Demo 9: Button Press
                    DemoCard(title: "Button", color: .indigo) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.indigo)
                            .frame(width: 80, height: 40)
                            .overlay {
                                Text("Tap")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .mithril(.buttonPress)
                            .loop(.forever)
                    }
                    
                    // Demo 10: Wiggle Effect
                    DemoCard(title: "Wiggle", color: .yellow) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                            .mithril()
                            .wiggle(duration: 0.8)
                            .loop(.forever)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Mithril Demo")
    }
}

// MARK: - Demo Card

struct DemoCard<Content: View>: View {
    let title: String
    let color: Color
    let content: () -> Content
    
    @State private var isPressed = false
    
    init(title: String, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.color = color
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 12) {
            content()
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Custom Shapes

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.9))
        path.addCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.3),
            control1: CGPoint(x: width * 0.5, y: height * 0.7),
            control2: CGPoint(x: width * 0.1, y: height * 0.5)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.1),
            control1: CGPoint(x: width * 0.1, y: height * 0.1),
            control2: CGPoint(x: width * 0.3, y: height * 0.1)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.3),
            control1: CGPoint(x: width * 0.7, y: height * 0.1),
            control2: CGPoint(x: width * 0.9, y: height * 0.1)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.9),
            control1: CGPoint(x: width * 0.9, y: height * 0.5),
            control2: CGPoint(x: width * 0.5, y: height * 0.7)
        )
        
        return path
    }
}

// MARK: - Preview

struct MithrilDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MithrilDemo()
        }
    }
}

#endif
