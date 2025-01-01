import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var confirmPassword = ""
    @State private var isLoggedIn = false
    @State private var isSignUp = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    WelcomeView(
                        isLoggedIn: $isLoggedIn,
                        email: $email,
                        password: $password,
                        username: $username,
                        confirmPassword: $confirmPassword
                    )
                } else {
                    if isSignUp {
                        SignUpView(
                            email: $email,
                            username: $username,
                            password: $password,
                            confirmPassword: $confirmPassword,
                            isSignUp: $isSignUp,
                            isLoggedIn: $isLoggedIn
                        )
                    } else {
                        LoginView(
                            email: $email,
                            password: $password,
                            isSignUp: $isSignUp,
                            isLoggedIn: $isLoggedIn
                        )
                    }
                }
            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    isLoggedIn = true
                }
            }
            .navigationBarHidden(true)
        }
    }
}


struct LoginView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 20) {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.bottom, 40)

                CustomTextField(placeholder: "Email", text: $email)

                CustomSecureField(placeholder: "Password", text: $password)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Button(action: login) {
                        Text("Login")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(colors: [.black, .pink]), startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }

                Button(action: { isSignUp.toggle() }) {
                    Text("Don't have an account? Sign Up")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .frame(width: 350)
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    errorMessage = "Email is not registered."
                case .wrongPassword:
                    errorMessage = "Incorrect password."
                case .invalidEmail:
                    errorMessage = "Invalid email address."
                default:
                    errorMessage = error.localizedDescription
                }
                return
            }

            isLoggedIn = true
        }
    }
}

struct SignUpView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 20) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.bottom, 40)

                CustomTextField(placeholder: "Email", text: $email)

                CustomTextField(placeholder: "Username", text: $username)

                CustomSecureField(placeholder: "Password", text: $password)

                CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Button(action: signUp) {
                        Text("Sign Up")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(colors: [.black, .pink]), startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }

                Button(action: { isSignUp.toggle() }) {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .frame(width: 350)
        }
    }

    func signUp() {
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            isSignUp = false
        }
    }
}

struct WelcomeView: View {
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @Binding var password: String
    @Binding var username: String
    @Binding var confirmPassword: String

    var body: some View {
        VStack {
            Text("Welcome!")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding()

            Text("You are successfully logged in.")
                .foregroundColor(.white)
                .padding()

            Button("Logout") {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                    resetFields()
                } catch let error {
                    print("Failed to log out: \(error.localizedDescription)")
                }
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.pink, .red]),
                        startPoint: .top,
                        endPoint: .bottomTrailing
                    ))
            )
            .padding(.top)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.pink, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea()
    }

    func resetFields() {
        email = ""
        password = ""
        username = ""
        confirmPassword = ""
    }
}


struct BackgroundView: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()

        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.pink, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 1000, height: 200)
            .rotationEffect(.degrees(135))
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true) 
                .foregroundColor(.white)

//             Image(systemName: "envelope")
//                 .foregroundColor(.white)
        }
        .padding(.horizontal)
        .frame(height: 40)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white),
            alignment: .bottom
        )
        .background(
            Text(placeholder)
                .foregroundColor(.white.opacity(0.6))
                .bold()
                .padding(.leading, 5)
                .opacity(text.isEmpty ? 1 : 0),
            alignment: .leading
        )
    }
}


struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack {
            if isSecure {
                SecureField("", text: $text)                     .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
            } else {
                TextField("", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
            }

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white),
            alignment: .bottom
        )
        .background(
            Text(placeholder)
                .foregroundColor(.white.opacity(0.6))
                .bold()
                .padding(.leading, 5)
                .opacity(text.isEmpty ? 1 : 0),
            alignment: .leading
        )
    }
}



extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
