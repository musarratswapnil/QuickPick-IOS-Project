import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        Text("Firebase Initialized!")
            .onAppear {
                if FirebaseApp.app() != nil {
                    print("Firebase is configured.")
                } else {
                    print("Firebase is not configured.")
                }
            }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
