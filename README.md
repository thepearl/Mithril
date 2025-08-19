# Mithril ⚡

**Declarative, chainable animation library for SwiftUI that makes complex animations simple and intuitive.**

Mithril transforms the way you create animations in SwiftUI by providing a fluent, chainable API that lets you compose beautiful animations with ease. Whether you need simple transitions or complex choreographed sequences, Mithril has you covered.

## ✨ Features

- **🔗 Chainable API**: Build complex animations by chaining simple steps
- **🎭 Rich Presets**: 20+ predefined animations for common use cases
- **⚡ Precise Control**: Fine-tune timing, easing, and sequencing
- **🔄 Flexible Looping**: Multiple repeat modes including forever, times, and conditional
- **🚀 Performance Optimized**: Lightweight with zero external dependencies
- **📱 Cross-Platform**: iOS 15+, macOS 12+, watchOS 8+, tvOS 15+

## 🚀 Quick Start

### Installation

Add Mithril to your project using Swift Package Manager:

```swift
.package(url: "https://github.com/thepearl/Mithril.git", from: "1.0.0")
```

### Basic Usage

```swift
import SwiftUI
import Mithril

struct ContentView: View {
    var body: some View {
        Text("Hello, Mithril!")
            .mithril(.fadeInUp)  // Use a preset
            .loop(.forever)
    }
}
```

## 🎯 Animation Chaining

Mithril's power comes from its chainable API that lets you sequence animations:

### Sequential Animations (`.then()`)

```swift
Rectangle()
    .fill(.blue)
    .mithril()
    .fadeIn(duration: 0.5)
    .then()  // Wait for previous to complete
    .scaleUp(to: 1.2, duration: 0.3)
    .then()
    .rotate(degrees: 180, duration: 0.4)
```

### Parallel Animations (`.and()`)

```swift
Circle()
    .fill(.red)
    .mithril()
    .scaleUp(to: 1.5, duration: 0.5)
    .and()  // Run simultaneously
    .rotate(degrees: 360, duration: 0.5)
    .and()
    .fadeOut(duration: 0.5)
```

## 🎨 Animation Types

### Fade Animations
```swift
.fadeIn(duration: 0.3)
.fadeOut(duration: 0.3)
.fadeTo(0.5, duration: 0.3)  // Fade to specific opacity
```

### Scale Animations
```swift
.scaleUp(to: 1.2, duration: 0.3)
.scaleDown(to: 0.8, duration: 0.3)
.scaleFrom(0.5, to: 1.5, duration: 0.4)
```

### Movement Animations
```swift
.moveTo(x: 100, y: 50, duration: 0.5)  // Absolute position
.moveBy(x: 20, y: -30, duration: 0.3)  // Relative movement
```

### Rotation Animations
```swift
.rotate(degrees: 45, duration: 0.3)
.rotate(radians: .pi, duration: 0.5)
.spin(duration: 2.0)  // Full 360° rotation
```

### Slide Animations
```swift
.slideIn(.left, distance: 200, duration: 0.5)
.slideOut(.right, distance: 150, duration: 0.4)
// Directions: .up, .down, .left, .right, .topLeading, .topTrailing, .bottomLeading, .bottomTrailing
```

### Special Effects
```swift
.shake(.horizontal, intensity: 10, duration: 0.6)
.pulse(scale: 1.2, duration: 0.8)
.wiggle(duration: 0.5)
.flash(duration: 0.4)
```

## 🎭 Animation Presets

Mithril includes 20+ carefully crafted presets for common scenarios:

### Entrance Animations
- `.fadeInUp` - Fade in from bottom with scale
- `.slideInLeft` - Slide in from left side
- `.zoomIn` - Zoom in with bounce effect
- `.bounceIn` - Bouncy entrance animation
- `.rotateIn` - Rotate and fade in

### Exit Animations
- `.fadeOutDown` - Fade out moving down
- `.slideOutRight` - Slide out to right
- `.zoomOut` - Zoom out and fade

### Attention Animations
- `.bounce` - Simple bounce effect
- `.flash` - Quick flash effect
- `.pulse` - Gentle pulsing
- `.shake` - Horizontal shake
- `.wobble` - Rotation wobble
- `.heartbeat` - Double pulse like heartbeat

### UI-Specific Presets
- `.buttonPress` - Button press feedback
- `.socialLike` - Social media like animation
- `.cardFlip` - Card flip transition
- `.addToCart` - Add to cart feedback
- `.listItem` - List item entrance

```swift
// Using presets
Button("Like") { }
    .mithril(.socialLike)

Text("Welcome!")
    .mithril(.fadeInUp)
    .delay(0.5)
```

## 🔄 Looping and Repetition

```swift
// Loop forever
.loop(.forever)

// Loop specific number of times
.loop(.times(3))

// Loop for duration
.loop(.duration(5.0))

// Loop until condition
.loop(.until { someCondition })

// Run once (default)
.loop(.once)
```

## ⏱️ Delays and Timing

```swift
Text("First")
    .mithril()
    .fadeIn()
    .delay(1.0)  // Wait 1 second
    .then()
    .scaleUp()
```

## 🌊 Spring Physics

Mithril includes realistic spring animations:

```swift
.spring(.smooth, duration: 0.6)    // Gentle spring
.spring(.snappy, duration: 0.4)    // Quick spring
.spring(.bouncy, duration: 0.8)    // Bouncy spring
.spring(.wobbly, duration: 1.0)    // Wobbly spring

// Custom spring
.spring(.custom(tension: 0.7, friction: 0.8), duration: 0.6)
```

## 🛠️ Custom Animations

Create your own animation transformations:

```swift
.custom { view in
    view
        .blur(radius: 5)
        .brightness(0.5)
}
```

## 💡 Real-World Examples

### Button Press Feedback
```swift
Button("Tap Me") {
    // Action
}
.mithril(.buttonPress)
```

### Loading Spinner
```swift
Image(systemName: "arrow.clockwise")
    .mithril()
    .spin(duration: 1.0)
    .loop(.forever)
```

### Card Entrance Animation
```swift
CardView()
    .mithril()
    .scaleFrom(0.8, to: 1.0, duration: 0.4)
    .and()
    .fadeIn(duration: 0.4)
    .and()
    .moveBy(x: 0, y: -20, duration: 0.4)
```

### Complex Sequence
```swift
Rectangle()
    .mithril()
    .scaleDown(to: 0.8, duration: 0.2)
    .then()
    .rotate(degrees: 180, duration: 0.4)
    .and()
    .scaleUp(to: 1.2, duration: 0.4)
    .then()
    .wiggle()
    .then()
    .scaleDown(to: 1.0, duration: 0.3)
    .loop(.times(3))
```

### Social Media Like
```swift
Image(systemName: isLiked ? "heart.fill" : "heart")
    .foregroundColor(isLiked ? .red : .gray)
    .mithril(isLiked ? .socialLike : nil)
```

## 🏗️ Architecture

Mithril is built around several core concepts:

- **AnimationBuilder**: Chainable builder for composing animations
- **AnimationStep**: Individual animation operations
- **AnimationPreset**: Predefined sequences of steps
- **AnimationModifier**: SwiftUI ViewModifier that executes animations

## 🔧 Advanced Usage

### Custom Presets
```swift
let customPreset = AnimationPreset.custom([
    .scaleFrom(from: 0.5, to: 1.2, duration: 0.3),
    .scaleFrom(from: 1.2, to: 1.0, duration: 0.2),
    .rotate(angle: .degrees(360), duration: 0.5)
])

view.mithril(customPreset)
```

### Parallel Animation Groups
```swift
// Multiple animations running in parallel
view.mithril()
    .scaleUp()
    .and()
    .rotate(degrees: 180)
    .and()
    .fadeOut()
```

## 📋 Requirements

- iOS 15.0+ / macOS 12.0+ / watchOS 8.0+ / tvOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## 🎮 Demo App

Mithril includes a comprehensive demo app showcasing all animations:

```swift
import SwiftUI
import Mithril

struct ContentView: View {
    var body: some View {
        NavigationView {
            MithrilDemo()  // Built-in demo
        }
    }
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

Mithril is available under the MIT license. See the LICENSE file for more info.

## 🙏 Acknowledgments

- Inspired by CSS animation libraries like Animate.css and React.
- Inspiration from SwiftUI community: https://github.com/dankinsoid/VDAnimation
- Built with ❤️ for the SwiftUI community

---

**Made with ⚡ by [The Pearl](https://github.com/thepearl)**
