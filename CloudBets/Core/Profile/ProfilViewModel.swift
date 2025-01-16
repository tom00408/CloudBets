//
//  ProfilViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 02.02.25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user : DBUser? = nil
    
    func loadCurrentUser() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            print("authDataResult geladen✅ \(authDataResult.uid)")
            self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            print("User Loaded in Profile View: \(String(describing: self.user))")
        } catch {
            print("Error loading user: \(error.localizedDescription)")
        }
    }
    
    func setUsername(newUsername: String){
        guard var user else {return}
        
        Task{
            try await UserManager.shared.setUsername(userId: user.userId, newUsername: newUsername)
            await loadCurrentUser()
        }
    }
    
}
