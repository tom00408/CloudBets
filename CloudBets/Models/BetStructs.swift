//
//  BetStructs.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 29.01.25.
//

import Foundation


struct Leg: Codable, Identifiable, Equatable {
    
    var id : String {homeTeam+awayTeam+market+outcome+String(odds)}
    
    let event : Event?
    
    let homeTeam: String
    let awayTeam: String
    
    let market: String
    
    let outcome: String
    let odds: Double
    let points: Double?
    
    let sportGroup: String?
    
    static let sample = Leg(
        
        event: nil,
        homeTeam: "Tottenham",
        awayTeam: "Liverpool",
        market: "h2h",
        outcome: "Tottenham",
        odds: 2.0,
        points: nil,
        sportGroup: "Soccer"
    )
    
    static let sample2 = Leg(
        event: nil,
        homeTeam: "Bayern München",
        awayTeam: "BVB Dortmund",
        market: "h2h",
        outcome: "Bayern München",
        odds: 1.8,
        points: -1.5,
        sportGroup: "Soccer"
    )
    
    
    
    
    /*
     Equatablity
     */
    
    static func == (lhs: Leg, rhs: Leg) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Bet: Codable, Identifiable{
    
    var id  = UUID()
    
    let stake: Double
    let odds: Double
    
    var payout: Double { return stake*odds}
    
    let legs: [Leg]
    
}
