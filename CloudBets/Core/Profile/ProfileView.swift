import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    
    @Binding var showSignInView: Bool
    @FocusState private var isTextFieldFocused: Bool // 🔥 Fokus-Status
    
    @State var isUserPremium: Bool? = false
    @State var username: String = "username"
    
    
    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea() // Hintergrundfarbe aus CD
            
            VStack {
                if let user = viewModel.user {
                    VStack(spacing: 16) {
                        // **Profilbild**
                        if let ppURL = user.photoUrl {
                            AsyncImage(url: URL(string: ppURL)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(CD.acc, lineWidth: 2) // Accent-Farbe aus CD
                                    )
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        // **Username **
                        
                        HStack{
                            if username == "user"{
                                TextField("Username", text: $username)
                                
                                    .cornerRadius(10)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(CD.txt1)
                                    .focused($isTextFieldFocused)
                                Button{
                                    viewModel.setUsername(newUsername: username)
                                    isTextFieldFocused = false
                                }label:{
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(CD.success)
                                }
                            }
                            else{
                                Text(username)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(CD.txt1)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(CD.acc)
                        .foregroundColor(CD.bg1)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 3)
                        
                        
                        // **User Info Card**
                        VStack(spacing: 8) {
                            
                            Text(user.email ?? "No Email")
                                .font(.headline)
                                .foregroundColor(CD.txt1)
                            
                            Text("User ID: \(user.userId)")
                                .font(.subheadline)
                                .foregroundColor(CD.txt2)
                                .padding(.horizontal)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CD.bg2)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 3)
                        
                        // **Premium Status Button**
                        Button {
                            isUserPremium = !(isUserPremium ?? false)
                        } label: {
                            HStack {
                                Image(systemName: isUserPremium ?? false ? "star.fill" : "star")
                                    .foregroundColor(isUserPremium ?? false ? .yellow : .gray)
                                Text(isUserPremium ?? false ? "Premium User" : "Upgrade to Premium")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isUserPremium ?? false ? CD.acc : CD.bg2)
                            .foregroundColor(isUserPremium ?? false ? .black : CD.txt1)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                } else {
                    Text("No User ID")
                        .font(.headline)
                        .foregroundColor(CD.txt2)
                        .padding()
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.loadCurrentUser()
                username = viewModel.user?.username ?? ""
            }
        }
        .navigationTitle("Profile")
        .accentColor(Color.yellow)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    UserSettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
}
