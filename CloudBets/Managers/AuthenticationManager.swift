//
//  AuthenticationManager.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 31.01.25.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email : String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL? .absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else{
            throw Terror.authError("Coudnt get authenticated User")
            
        }
        return AuthDataResultModel(user: user)
    }
    
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    
    func delete() async throws{
        guard let user = Auth.auth().currentUser else{
            throw Terror.authError("Couldnt get User to delete")
        }
        try await user.delete()
    }
    
    
}

//MARK: SIGN IN EMAIL PASSWORD
extension AuthenticationManager{
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

}


// MARK: SIGN IN SSO
extension AuthenticationManager{
    
    
    
    func signInWithGoogle(token: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
