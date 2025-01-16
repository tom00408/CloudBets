import Foundation
import SwiftUI


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    
 
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("⚠️ No email or password provided")
            return
        }
        
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("⚠️ No email or password provided")
            return
        }
        
        
        let _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
}
