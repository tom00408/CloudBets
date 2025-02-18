import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @State private var signInError: SignInError?

    struct SignInError: Identifiable {
        let id = UUID()
        let message: String
    }

    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea() // Hintergrundfarbe aus CD

            VStack(spacing: 20) {
                Text("Willkommen bei CloudBets")
                    .font(.largeTitle.bold())
                    .foregroundColor(CD.txt1)
                    .padding(.top, 40)

                Text("Melde dich an, um das Beste aus der App herauszuholen.")
                    .font(.subheadline)
                    .foregroundColor(CD.txt2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Sign-in mit E-Mail
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Mit E-Mail anmelden")
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(CD.acc)
                        .cornerRadius(12)
                        .shadow(color: CD.bg3, radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 30)

                // Google Sign-In Button
                GoogleSignInButton(
                    viewModel: GoogleSignInButtonViewModel(
                        scheme: .dark,
                        style: .wide,
                        state: .normal
                    )
                ) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            signInError = SignInError(message: error.localizedDescription)
                        }
                    }
                }
                .frame(height: 55)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .alert(item: $signInError) { error in
            Alert(title: Text("Fehler"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Anmelden")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
