# SwiftUI Animated Launch Splash

A reusable animated splash implementation for SwiftUI with an expanding mask transition.

The native iOS Launch Screen remains static, while the application's real root interface is rendered immediately underneath a custom SwiftUI splash overlay.

When the animation finishes, the overlay simply disappears and reveals the already prepared interface.

## Demo

https://github.com/user-attachments/assets/15076174-56c1-4387-90f5-ac14aedfd26a

## Launch flow

```text
Static native Launch Screen
→ Root view with animated overlay
→ Overlay disappears
```

A common alternative is to display a separate animated splash screen first and replace it with the root interface afterward:

```text
Static native Launch Screen
→ Animated splash screen
→ Root view
```

With that approach, the application must explicitly switch from the splash screen to the root view.

In this implementation, the root interface is already displayed underneath the animation. No additional screen replacement is required when the splash completes.

## Features

- Reusable SwiftUI `ViewModifier`
- Custom SwiftUI logo support
- Configurable animation timings
- Expanding mask transition
- Root interface rendered underneath the splash
- No third-party dependencies
- Example application included

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- SwiftUI

## Project structure

```text
AnimatedLaunchSplash
├── App
│   └── AnimatedLaunchSplashApp.swift
├── Features
│   └── LaunchSplash
│       ├── AppLaunchSplash.swift
│       └── SystemSplashLogo.swift
├── Screens
│   └── ContentView.swift
└── Resources
    └── Assets.xcassets
```

## Usage

Apply the modifier to the root view of your application:

```swift
import SwiftUI

@main
struct AnimatedLaunchSplashApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.launchBackground
                    .ignoresSafeArea()

                ContentView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .background {
                        Color.launchBackground
                            .ignoresSafeArea()
                    }
            }
            .appLaunchSplash {
                SystemSplashLogo()
            }
        }
    }
}
```

You can use any SwiftUI view as the splash logo:

```swift
.appLaunchSplash {
    Image(systemName: "swift")
        .font(.system(size: 64, weight: .bold))
        .foregroundStyle(.white)
}
```

The included demo uses a system symbol inside a rounded gradient container.

## Custom configuration

Animation timing can be adjusted through `AppLaunchSplashConfig`:

```swift
let config = AppLaunchSplashConfig(
    backgroundColor: .launchBackground,
    initialDelay: 0.18,
    logoAppearDuration: 0.42,
    holdDuration: 0.35,
    punchDuration: 0.72,
    expandedScale: 34
)
```

Pass the configuration into the modifier:

```swift
ContentView()
    .appLaunchSplash(config: config) {
        SystemSplashLogo()
    }
```

### Configuration parameters

- `backgroundColor` — splash overlay background
- `initialDelay` — delay before the logo appears
- `logoAppearDuration` — logo appearance animation duration
- `holdDuration` — pause before the final transition
- `punchDuration` — expanding mask animation duration
- `expandedScale` — final scale of the logo mask

## How the transition works

During the final stage, the logo is rendered as a cutout inside the splash overlay:

```swift
logo()
    .scaleEffect(punchScale)
    .blendMode(.destinationOut)
```

The overlay is grouped using:

```swift
.compositingGroup()
```

As the logo grows, the cutout expands and reveals the root interface underneath.

## Launch Screen background configuration

The native Launch Screen, the SwiftUI root view, and the animated splash overlay must use exactly the same background color.

Otherwise, a visible color change, black frame, or brief flash may appear during startup.

### 1. Create a color asset

In `Assets.xcassets`, create a Color Set named:

```text
LaunchBackground
```

Example color:

```text
Red:   0.04
Green: 0.06
Blue:  0.13
Alpha: 1.00
```

Approximate hex value:

```text
#0A0F21
```

### 2. Configure the native Launch Screen

Open:

```text
Target
→ Info
→ Launch Screen
→ Background color
```

Set its value to:

```text
LaunchBackground
```

### 3. Use the same asset in SwiftUI

```swift
extension Color {
    static let launchBackground = Color("LaunchBackground")
}
```

Then use it both underneath the root interface and inside `AppLaunchSplashConfig`.

## Important note

This implementation does not animate the native iOS Launch Screen.

The native Launch Screen remains static. The animation begins only after the SwiftUI application has launched.

The splash should remain short and should not be used to hide long-running network requests or application initialization.

## Running the demo

1. Clone the repository.
2. Open `AnimatedLaunchSplash.xcodeproj`.
3. Select an iPhone simulator or physical device.
4. Build and run the project.
5. Stop the application completely and launch it again to replay the full startup sequence.

## License

This project is available under the MIT License. See the `LICENSE` file for details.
