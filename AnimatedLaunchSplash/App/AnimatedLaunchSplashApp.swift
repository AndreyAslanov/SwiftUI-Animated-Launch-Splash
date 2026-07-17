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
