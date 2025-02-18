import SwiftUI
import FirebaseAuth

struct UserSettingsView: View {
    
    @StateObject private var viewModel = UserSettingsViewModel()
    @Binding var showSignInView: Bool

    @FocusState var isTextFieldFocused: Bool
    @State private var username: String = ""

    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea() // Hintergrundfarbe
            
            VStack(spacing: 16) {
                // **Benutzer E-Mail Card**
                VStack {
                    Text("Angemeldet als")
                        .font(.subheadline)
                        .foregroundColor(CD.txt2)
                    
                    Text(viewModel.userEmail)
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                        .padding(.top, 2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(CD.bg2)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 3)
                .padding(.horizontal)

                // **Change Username**
                /*Text("Change Username")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(CD.txt1)*/
                Section("User"){
                    HStack {
                        TextField("Change Username", text: $username)
                            .textFieldStyle(PlainTextFieldStyle()) // Kein extra Styling
                            .cornerRadius(10)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                            .focused($isTextFieldFocused)
                        
                        Button {
                            if !username.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.setUsername(newUsername: username)
                            }
                            isTextFieldFocused = false
                        } label: {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(CD.success)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(CD.acc)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
                }.padding()

                // **Logout Button**
                Button(action: {
                    Task {
                        do {
                            try viewModel.singOut()
                            showSignInView = true
                        } catch {
                            print("❌ Fehler beim Logout:", error)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.white)
                        Text("Log out")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(CD.acc)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
                }
                .padding(.horizontal)

                // **Account Löschen Button (Destructive)**
                Button(role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showSignInView = true
                        } catch {
                            print("❌ Fehler beim Account Löschen:", error)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                        Text("Delete Account")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
                }
                .padding(.horizontal)
                
                Spacer() // Platz nach unten für bessere UX
            }
            .padding(.top, 40)
        }
        .onAppear {
            Task {
                await viewModel.loadCurrentUser()
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    UserSettingsView(showSignInView: .constant(false))
}
