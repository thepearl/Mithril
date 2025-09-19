fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios ci

```sh
[bundle exec] fastlane ios ci
```

Run CI tasks for iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

Prepare and create a new release

### ios test_ios

```sh
[bundle exec] fastlane ios test_ios
```

Run tests on iOS only

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Lint code with SwiftLint

### ios lint_fix

```sh
[bundle exec] fastlane ios lint_fix
```

Auto-fix SwiftLint issues

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
