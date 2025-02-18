//
//  PlaceBetViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import Foundation

class PlaceBetViewModel: ObservableObject{
    
    
    @Published private(set) var user : DBUser? = nil
    
    
    @Published var legs : [Leg] = []
    
    var price : Double {
        if legs.isEmpty{
            return 1
        }
        var sum = 1.0
        for leg in legs{
            sum *= leg.odds
        }
        return sum
    }
    @Published var stake : String = "5"
    
    var isBetValid : Bool {
        return price > 1
        && !legs.isEmpty
    }
    
    func loadCurrentUser() async {
        do {
            let authenticatedUser = try await UserManager.shared.getAuthenticatedUser()
            DispatchQueue.main.async {
                self.user = authenticatedUser
            }
        } catch {
            print("Failed to load user: \(error)")
            DispatchQueue.main.async {
                self.user = nil
            }
        }
    }

    
    
    func setStake(stake: String){
        self.stake = stake
    }
    
    //🪜1️⃣2️⃣5️⃣🔒🔁
    func getEmoji(string : String) -> String{
        switch string{
        case "Leiter":
            return "🪜"
        case "1":
            return "1️⃣"
        case "2":
            return "2️⃣"
        case "5":
            return "5️⃣"
        default:
            return string
            
        }
    }
    
    func containsLeg(leg: Leg) -> Bool{
        return legs.contains(where: {$0.homeTeam == leg.homeTeam && $0.awayTeam == leg.awayTeam && $0.market == leg.market})
    }
    
    func containsExactLeg(leg: Leg) -> Bool{
        return legs.contains(where: {$0.id == leg.id})
    }
    
    
    func selectLeg(leg: Leg){
        if legs.count > 20{
            print("Zu viele Auswahlen im Schein")
            return
        }
        if containsLeg(leg: leg){
            print("Bereits etwas von diesem Markt in der Auswahl")
            /*
             TODO
             UI Anzeige für diesen Error
             */
            return
        }
        
        legs.append(leg)
        
        print("leg selected \(leg.homeTeam) - \(leg.awayTeam)")
    }
    
    func removeLeg(leg: Leg){
        if let index = legs.firstIndex(of: leg){
            legs.remove(at: index)
            print("leg erfolgreich entfernt \(leg.homeTeam) - \(leg.awayTeam)")
        }else{
            print("Leg wurde nicht in der Liste gefunden")
        }
        
    }
    
    
    func placeBet() async {
        if !isBetValid {
            return
        }
        
        if let userId = user?.userId {
            let bet = Bet(userId: userId, stake: stake, odds: price, legs: legs)
            do {
                try await UserManager.shared.uploadPlacedBet(userId: userId, bet: bet)
                DispatchQueue.main.async {
                    print("Schein hochgeladen bei userId: \(userId) --> \(bet.id)")
                    self.legs.removeAll() // Auswahl nach dem Platzieren der Wette leeren
                }
            } catch {
                DispatchQueue.main.async {
                    print("Fehler beim Senden des Tipps: \(error)")
                }
            }
            
            // 🚀 LEGS AUF DEM HAUPT-THREAD LEEREN
            DispatchQueue.main.async {
                self.legs = []
            }
        }
    }


    
    
}

