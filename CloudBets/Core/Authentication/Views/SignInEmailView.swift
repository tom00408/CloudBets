import SwiftUI

struct SignInEmailView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var isSignInEnabled: Bool {
        return viewModel.email.count > 6 && viewModel.password.count > 6
    }
  
    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea() // Hintergrundfarbe

            VStack(spacing: 20) {
                Image("iconBetter")
                    .resizable() // Sorgt dafür, dass das Bild skaliert wird
                    .scaledToFit() // Verhindert Verzerrungen
                    .frame(width: 200, height: 200)
                    .clipShape(Circle()) // Macht das Bild rund
                    .overlay(
                        Circle().stroke(CD.acc, lineWidth: 4) // Optionaler Rand in deiner Akzentfarbe
                    )
                    .shadow(radius: 5) // Optional: Leichter Schatten für mehr Tiefe

                // Begrüßungstext
                Text("Willkommen zurück!")
                    .font(.largeTitle.bold())
                    .foregroundColor(CD.txt1)
                
                Text("Melde dich mit deiner E-Mail und deinem Passwort an oder lege einen Nutzer an, um fortzufahren ")
                    .font(.subheadline)
                    .foregroundColor(CD.txt2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Eingabefelder
                VStack(spacing: 15) {
                    TextField("", text: $viewModel.email, prompt: Text("E-Mail-Adresse").foregroundColor(.white))
                        .padding()
                        .background(CD.accHover.opacity(0.4))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .accentColor(CD.txt1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(CD.acc, lineWidth: 1)
                                .opacity(viewModel.email.isEmpty ? 0.3 : 1)
                        )


                    SecureField("", text: $viewModel.password, prompt: Text("Passwort").foregroundColor(.white))
                        .padding()
                        .background(CD.accHover.opacity(0.4))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(CD.acc, lineWidth: 1)
                                .opacity(viewModel.password.isEmpty ? 0.3 : 1)
                        )

                }
                .padding(.horizontal, 30)

                // Sign In Button
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                            print("CATCH SIGNUP")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            print("User logged in successfully! :)))")
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                            print("CATCH SIGNIN")
                        }
                        print("Task DONE")
                    }
                } label: {
                    Text("Anmelden")
                        .font(.headline)
                        .foregroundColor(isSignInEnabled ? CD.txt1 : CD.txt2) // Deaktivierte Farbe
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isSignInEnabled ? CD.acc : CD.accHover.opacity(0.5)) // Deaktivierter Button
                        .cornerRadius(12)
                        .shadow(color: CD.bg3.opacity(isSignInEnabled ? 0.3 : 0), radius: 5, x: 0, y: 3)
                        .animation(.easeInOut(duration: 0.3), value: isSignInEnabled)
                }
                .disabled(!isSignInEnabled) // Button nur aktiv, wenn gültige Eingaben

                // Spacer für bessere Ausrichtung
                Spacer()
            }
            .padding(.vertical, 40)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
}
