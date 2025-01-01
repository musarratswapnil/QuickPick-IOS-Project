


import SwiftUI
import FirebaseCore

@main
struct QuickPickApp: App {
        init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
