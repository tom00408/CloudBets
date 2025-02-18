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
    
    var status: String
    var score: Score?
    
    static let sample = Leg(
        
        eventId: "123345",
        homeTeam: "Tottenham",
        awayTeam: "Liverpool",
        market: "h2h",
        outcome: "Tottenham",
        odds: 2.0,
        points: nil,
        sportGroup: "Soccer",
        status: BettingStatus.pending.rawValue
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
        status: BettingStatus.lost.rawValue
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
    
    var id : String = UUID().uuidString
    var userId : String?
    
    let stake: String
    let odds: Double
    let legs: [Leg]
    
    var status : String = BettingStatus.pending.rawValue
    
    var locks: Int = 0
    var reBets: Int = 0
    
    
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
}


enum BettingStatus: String, Codable{
    case pending
    case won
    case lost
    case refunded
}
