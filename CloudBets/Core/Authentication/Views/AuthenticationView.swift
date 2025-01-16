//
//  AuthenticationView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 31.01.25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            }label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(CD.txt1)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(CD.acc)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(
                viewModel: GoogleSignInButtonViewModel(
                    scheme: .dark,
                    style: .wide,
                    state: .normal
                )
            ){
                Task{
                    do{
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            
            Spacer()
        }.padding()
        .navigationTitle("Sign In")
        
        
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}

