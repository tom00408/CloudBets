//
//  BetStructs.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 29.01.25.
//

import Foundation


struct Score: Codable, Identifiable{
    let id : String
    let home: Int
    let away: Int
    let last_update : String
}

struct Leg: Codable, Identifiable, Equatable {
    
    var id: String { "\(homeTeam)-\(awayTeam)-\(market)-\(outcome)-\(String(format: "%.2f", odds))" }
    
    let eventId : String
    
    let homeTeam: String
    let awayTeam: String
    
    let market: String
    
    let outcome: String
    let odds: Double
    let points: Double?
    
    let sportGroup: String?
    
    var status: BettingStatus
    var score: Score? = nil
    
    static let sample = Leg(
        
        eventId: "123345",
        homeTeam: "Tottenham",
        awayTeam: "Liverpool",
        market: "h2h",
        outcome: "Tottenham",
        odds: 2.0,
        points: nil,
        sportGroup: "Soccer",
        status: BettingStatus.pending
    )
    
    static let sample2 = Leg(
        eventId: "nilasdasdas",
        homeTeam: "Bayern München",
        awayTeam: "BVB Dortmund",
        market: "h2h",
        outcome: "Bayern München",
        odds: 1.8,
        points: -1.5,
        sportGroup: "Soccer",
        status: BettingStatus.pending
    )
    
    
    
    
    /*
     Equatablity
     */
    
    static func == (lhs: Leg, rhs: Leg) -> Bool {
        return lhs.eventId == rhs.eventId &&
        lhs.homeTeam == rhs.homeTeam &&
        lhs.awayTeam == rhs.awayTeam &&
        lhs.market == rhs.market &&
        lhs.outcome == rhs.outcome
        
    }
}


struct Bet: Codable, Identifiable{
    
    var id  = UUID()
    var userId : String
    
    let stake: String
    let odds: Double
    let legs: [Leg]
    
    var status : BettingStatus = .pending
    
    var locks: Int = 0
    var reBets: Int = 0
    
    
    
}


enum BettingStatus: Codable{
    case pending
    case won
    case lost
    case refunded
}
