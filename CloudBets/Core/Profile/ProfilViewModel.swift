//
//  ProfilViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 02.02.25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user: DBUser? = nil
    @Published var totalLocks: Int = 0
    @Published var totalReBets: Int = 0
    @Published var totalBets: Int = 0
    
    func loadCurrentUser() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            
            // Aktualisiere Locks und Rebets automatisch
            DispatchQueue.main.async {
                self.totalLocks = self.getLocks()
                self.totalReBets = self.getRebets()
                self.totalBets = self.getBets()
            }
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
    
    func getLocks()-> Int{
        if let user = user{
            var locks = 0
            for bet in user.bets{
                locks += bet.locks
            }
            return locks
        }
        return 0
    }
    
    func getRebets()-> Int{
        if let user = user{
            var reBet = 0
            for bet in user.bets{
                reBet += bet.reBets
            }
            return reBet
        }
        return 0
    }
    
    func getBets() -> Int{
        if let user = user{
            var bets = user.bets.count
            return bets
        }
        return 0
    }
    
}
