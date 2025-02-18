//
//  MyBetsViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 04.02.25.
//

import Foundation

class MyBetsViewModel: ObservableObject {
    @Published var user: DBUser? = nil
    
    func loadUser() async {
        do {
            let authenticatedUser = try await UserManager.shared.getAuthenticatedUser()
            DispatchQueue.main.async {
                self.user = authenticatedUser
            }
        } catch {
            print("Fehler beim Laden des Nutzers: \(error)")
        }
    }
}
