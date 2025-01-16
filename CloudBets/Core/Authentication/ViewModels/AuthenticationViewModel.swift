//
//  AuthenticationViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 01.02.25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct GoogleSignInResultModel{
    let idToken : String
    let accessToken : String
    let name: String?
    let email: String?

}

@MainActor
final class AuthenticationViewModel: ObservableObject{

    func signInGoogle()async throws{
        
        guard let topVC = Utilities.shared.topViewController() else {
            throw Terror.topVCNotFound
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC )
        
        guard let idToken : String = gidSignInResult.user.idToken?.tokenString else{
            throw Terror.noIdToken
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        
        let tokens = GoogleSignInResultModel(
            idToken: idToken,
            accessToken: accessToken,
            name: name,
            email: email
        )
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(token: tokens)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        
    }
    
}
