# CI/CD Setup for Mithril

This document describes the CI/CD pipeline setup for the Mithril Swift package using GitHub Actions and Fastlane.

## 🚀 Overview

The CI/CD pipeline includes:
- **Automated testing** on macOS platform
- **Code quality checks** with SwiftLint
- **Package validation** to ensure Swift Package Manager compatibility
- **Release automation** with version tagging and GitHub releases
- **Fastlane integration** for iOS-specific workflows

## 📁 Files Structure

```
├── .github/
│   └── workflows/
│       ├── ci.yml          # Main CI workflow
│       └── release.yml     # Release automation
├── fastlane/
│   ├── Appfile            # Fastlane app configuration
│   └── Fastfile           # Fastlane lanes and actions
├── .swiftlint.yml         # SwiftLint configuration
├── Gemfile                # Ruby dependencies
└── CI_CD_README.md        # This file
```

## 🔄 Workflows

### CI Workflow (`.github/workflows/ci.yml`)

Triggers on:
- Push to `master` or `develop` branches
- Pull requests to `master` branch

**Jobs:**
1. **Test macOS** - Runs tests on macOS platform
2. **SwiftLint** - Code quality and style checks
3. **Package Validation** - Validates Swift Package Manager compatibility
4. **Fastlane** - Runs Fastlane CI lane (only on master branch)

### Release Workflow (`.github/workflows/release.yml`)

Triggers on:
- Git tags matching `v*` pattern (e.g., `v1.0.0`)

**Actions:**
1. Validates the package
2. Runs tests
3. Generates release notes from git commits
4. Creates GitHub release
5. Runs Fastlane release lane

## 🛠 Fastlane Lanes

### Available Lanes

```bash
# Run CI tasks (lint + test + validate)
fastlane ios ci

# Create a new release
fastlane ios release

# Test on all platforms
fastlane ios test_all_platforms

# Run SwiftLint
fastlane ios lint

# Auto-fix SwiftLint issues
fastlane ios lint_fix
```

## 🚀 Getting Started

### Prerequisites

1. **Ruby** (3.0+)
2. **Bundler**
3. **Xcode** (15.0+)
4. **SwiftLint**

### Setup

1. **Install dependencies:**
   ```bash
   # Install Ruby dependencies
   bundle install
   
   # Install SwiftLint (if not already installed)
   brew install swiftlint
   ```

2. **Run initial setup:**
   ```bash
   # Initialize Fastlane (if needed)
   fastlane init
   
   # Run CI to verify setup
   fastlane ios ci
   ```

## 📋 Usage

### Running Tests Locally

```bash
# Run all CI checks
fastlane ios ci

# Test on macOS
xcodebuild test -scheme Mithril -destination "platform=macOS"

# Run SwiftLint
swiftlint
```

### Creating a Release

#### Method 1: Using Fastlane (Recommended)
```bash
# Create and push a new release
fastlane ios release
```

#### Method 2: Manual Git Tags
```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

### Code Quality

```bash
# Check code style
fastlane ios lint

# Auto-fix issues
fastlane ios lint_fix
```

## ⚙️ Configuration

### SwiftLint Configuration

Customize code style rules in `.swiftlint.yml`:
- Line length: 120 characters (warning), 150 (error)
- Function body length: 50 lines (warning), 100 (error)
- Enabled opt-in rules for better code quality

### Platform Support

Testing platform:
- **macOS**: Latest macOS

Note: iOS, watchOS, and tvOS testing have been removed due to simulator availability issues in the GitHub Actions environment.

### Xcode Versions

Currently configured for:
- Xcode 15.0
- Swift 5.9+

## 🔧 Customization

### Adding New Platforms

Currently only macOS testing is supported. To add other platforms, edit the workflow in `.github/workflows/ci.yml` and ensure the target simulators are available in the GitHub Actions environment.

### Custom Fastlane Lanes

Add new lanes in `fastlane/Fastfile`:
```ruby
lane :your_custom_lane do
  # Your custom actions here
end
```

### Environment Variables

Set these in GitHub repository secrets if needed:
- `FASTLANE_USER`: Apple ID for App Store Connect
- `FASTLANE_PASSWORD`: App-specific password
- `MATCH_PASSWORD`: Match repository password

## 🐛 Troubleshooting

### Common Issues

1. **Xcode version mismatch**
   - Update the Xcode version in workflow files
   - Ensure local Xcode matches CI version

2. **SwiftLint failures**
   - Run `fastlane ios lint_fix` to auto-fix issues
   - Check `.swiftlint.yml` for rule configuration

3. **Test failures**
   - Verify all platforms are properly configured
   - Check simulator availability

4. **Fastlane issues**
   - Run `bundle update` to update dependencies
   - Check Ruby version compatibility

### Debug Commands

```bash
# Verbose Fastlane output
fastlane ios ci --verbose

# Check Swift package
swift package resolve
swift build
swift test

# Validate Xcode project
xcodebuild -list
```

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/rule-directory.html)
- [Swift Package Manager](https://swift.org/package-manager/)

## 🤝 Contributing

When contributing to the CI/CD setup:
1. Test changes locally first
2. Update this README if adding new features
3. Ensure backward compatibility
4. Document any new environment variables or secrets needed