//
//  UserSettingsViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 31.01.25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class UserSettingsViewModel: ObservableObject{
    
    @Published var userEmail: String = "No User"
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    @Published private(set) var user : DBUser? = nil
    
    init() {
        addAuthStateListener()
    }
    
    func loadCurrentUser() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            //print("authDataResult geladen✅ \(authDataResult.uid)")
            self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            //print("User Loaded in Profile View: \(String(describing: self.user))")
        } catch {
            print("Error loading user: \(error.localizedDescription)")
        }
    }
    
    
    deinit {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }
    
    /// Startet das Live-Tracking des User-Status
    private func addAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.userEmail = user?.email ?? "No User"
                //print("✅ User-Email aktualisiert:", self?.userEmail ?? "No Email")
            }
        }
    }
    
    
    func singOut() throws {
        try AuthenticationManager.shared.signOut()
        print("User Signed Out📉")
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
        print("User Deleted📉")
    }
    
    func setUsername(newUsername: String){
        if let user = user{
            Task{
                try await UserManager.shared.setUsername(userId: user.userId, newUsername: newUsername)
            }
        }
    }
}
