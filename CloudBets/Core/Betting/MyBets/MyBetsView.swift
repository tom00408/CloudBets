//
//  MyBetsView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import SwiftUI




struct MyBetsView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = MyBetsViewModel()
    
    var body: some View {
            ZStack {
                CD.bg1
                    .ignoresSafeArea()
                ScrollView {
                    
                    GetTokenButtonView(token: Token.OnexToken)
                    GetTokenButtonView(token: Token.ladderToken)
                    GetTokenButtonView(token: Token.rebetToken)
                    
                    VStack {
                        if let user = viewModel.user {
                            if user.bets.isEmpty {
                                Text("Noch keine Wetten erstellt!")
                                    .foregroundColor(CD.acc)
                            } else {
                                ForEach(user.bets, id: \.id) { bet in
                                    MyBetRowView(
                                        bet: bet,
                                        interactive: false,
                                        showUser: false
                                    )
                                        .padding(.bottom, 10)
                                }
                            }
                        } else {
                            Text("Kein Benutzer gefunden")
                                .foregroundColor(CD.acc)
                        }
                    }.padding()
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadUser()
                }
            }
            .navigationTitle("MyBets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        UserSettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                            .foregroundColor(CD.acc)
                    }
                    
                }
                ToolbarItem(placement: .principal) { // Sorgt dafür, dass der Titel anpassbar bleibt
                        Text("Deine Wetten")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(CD.acc) // Deine gewünschte Farbe setzen
                    }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        ProfileView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.headline)
                            .foregroundColor(CD.acc)
                    }
                    
                }
            }.toolbarBackgroundVisibility(Visibility.hidden, for: .navigationBar)
            
            
        }
    }



#Preview {
    NavigationStack{
        MyBetsView(showSignInView: .constant(false))
            .navigationTitle("My Bets")
    }
}
