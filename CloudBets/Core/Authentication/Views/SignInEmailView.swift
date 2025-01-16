//
//  SignInEmailView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 31.01.25.
//

import SwiftUI



struct SignInEmailView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = SignInEmailViewModel()
    
  
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(CD.accHover.opacity(0.4))
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(CD.accHover.opacity(0.4))
                .cornerRadius(10)

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
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(CD.txt1)
                    .padding()
                    .frame(maxWidth: 300)
                    .background(CD.acc)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
}
