
import SwiftUI

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
                    WelcomeView(isLoggedIn: $isLoggedIn)  // Home page view after login
                } else {
                    if isSignUp {
                        SignUpView(email: $email, username: $username, password: $password, confirmPassword: $confirmPassword, isSignUp: $isSignUp, isLoggedIn: $isLoggedIn)
                    } else {
                        LoginView(email: $email, password: $password, isSignUp: $isSignUp, isLoggedIn: $isLoggedIn)
                    }
                }
            }
            .navigationBarHidden(true)  // Hide navigation bar
        }
    }
}

struct LoginView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 200)
                .rotationEffect(.degrees(135))
            
            VStack(spacing: 20) {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    login()
                } label: {
                    Text("Login")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.black, .pink], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                Button {
                    isSignUp.toggle()
                } label: {
                    Text("Don't have an account? Sign Up")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            .frame(width: 350)
        }
    }
    
    func login() {
        // Placeholder for login logic
        // If login is successful, set isLoggedIn to true
        isLoggedIn = true
    }
}

struct SignUpView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 200)
                .rotationEffect(.degrees(135))
            
            VStack(spacing: 20) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                TextField("Username", text: $username)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: username.isEmpty) {
                        Text("Username")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: confirmPassword.isEmpty) {
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    signUp()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.black, .pink], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                Button {
                    isSignUp.toggle()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            .frame(width: 350)
        }
    }
    
    func signUp() {
        // Placeholder for sign up logic
        // If sign up is successful, navigate back to the Login view
        isSignUp = false
    }
}

struct WelcomeView: View {
    @Binding var isLoggedIn: Bool
    
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
                isLoggedIn = false // Log out the user
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
            )
            .padding(.top)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.pink, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
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
