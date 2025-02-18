import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    @Binding var showSignInView: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    @State var isUserPremium: Bool? = false
    @State var username: String = "username"
    
    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea() // Hintergrundfarbe
            
            ScrollView {
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
                                            Circle().stroke(CD.acc, lineWidth: 2)
                                        )
                                        .shadow(radius: 5)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                            // **Username**
                            HStack {
                                if username == "user" {
                                    TextField("Username", text: $username)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(CD.txt1)
                                        .focused($isTextFieldFocused)
                                    
                                    Button {
                                        viewModel.setUsername(newUsername: username)
                                        isTextFieldFocused = false
                                    } label: {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(CD.success)
                                    }
                                } else {
                                    Text(username)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(CD.txt1)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(CD.acc)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 3)
                            
                            // **Locks, Bets & Rebets**
                            HStack {
                                Spacer()
                                Text("\(viewModel.totalBets) 🧾")
                                    .padding(4)
                                    .background(CD.acc.opacity(0.7))
                                    .cornerRadius(8)
                                Spacer()
                                Text("\(viewModel.totalLocks) 🔒")
                                    .padding(4)
                                    .background(CD.acc.opacity(0.7))
                                    .cornerRadius(8)
                                Spacer()
                                Text("\(viewModel.totalReBets) 🔁")
                                    .padding(4)
                                    .background(CD.acc.opacity(0.7))
                                    .cornerRadius(8)
                                Spacer()
                            }
                            .padding()
                            .background(CD.warning)
                            .cornerRadius(16)
                            
                            // **Tokens**
                            let tokens = user.tokens

                            HStack {
                                Spacer()
                                if tokens.isEmpty {
                                    Text("No Tokens :(")
                                        .padding(4)
                                        .background(Color.gray.opacity(0.7))
                                        .cornerRadius(8)
                                    Spacer()
                                } else {
                                    ForEach(tokens.sorted(by: { $0.value > $1.value }), id: \.key) { key, count in
                                        if let token = Token.tokenFinder[key] {
                                            Text("\(token.symbol) x\(count)")  // 🔥 Sicherer Zugriff
                                                .padding(4)
                                                .background(Color.blue.opacity(0.7))
                                                .cornerRadius(8)
                                        } else {
                                            Text("\(key) x\(count)")  // 🔥 Fallback für unbekannte Token
                                                .padding(4)
                                                .background(Color.red.opacity(0.7)) // Unbekannte Token anders einfärben
                                                .cornerRadius(8)
                                        }
                                        Spacer()
                                    }
                                }
                            }


                            .padding()
                            .background(CD.warning)
                            .cornerRadius(16)
                            
                            // **Wetten TabView**
                            /*VStack {
                                if !user.bets.isEmpty {
                                    GeometryReader { geometry in
                                        TabView {
                                            ForEach(user.bets, id: \.id) { bet in
                                                ScrollView{
                                                    MyBetRowView(bet: bet, interactive: false)
                                                        .frame(width: geometry.size.width)
                                                        .padding()
                                                }.frame(height: 500)
                                            }
                                        }
                                        .tabViewStyle(.page(indexDisplayMode: .always))
                                        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                                        .frame(height: 500)
                                    }
                                    .frame(height: 500)
                                } else {
                                    Text("Keine Wetten verfügbar")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            }*/
                            
                            // **User Info Card**
                            VStack(spacing: 8) {
                                Text(user.email ?? "No Email")
                                    .font(.headline)
                                    .foregroundColor(CD.txt1)
                                
                                Text("User ID: \(user.userId)")
                                    .font(.subheadline)
                                    .foregroundColor(CD.txt2)
                            }
                            .padding()
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
        }
        .onAppear {
            Task {
                await viewModel.loadCurrentUser()
                username = viewModel.user?.username ?? ""
            }
        }
        .navigationTitle("Profile")
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
        }.toolbarBackgroundVisibility(Visibility.hidden, for: .navigationBar)
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
