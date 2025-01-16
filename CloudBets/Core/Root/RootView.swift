//
//  RootView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 31.01.25.
//

import SwiftUI



struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack() {
            if !showSignInView{
                
                ContentView(showSignInView: $showSignInView)
                //ProfileView(showSignInView: $showSignInView)
                
            }           
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }



        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
            .onAppear {
                print("🔄 fullScreenCover geöffnet, showSignInView:", showSignInView)
            }
            .onDisappear {
                print("✅ fullScreenCover geschlossen")
            }
        }


    }
}

#Preview {
    RootView()
}
