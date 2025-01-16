//
//  PlaceBetViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import Foundation

class PlaceBetViewModel: ObservableObject{
    
    
    
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
    
    
    func setStake(stake: String){
        self.stake = stake
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
    
    
    func placeBet(){
        
        
        
    }
    
    
}

