//
//  Structs.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 16.01.25.
//

import Foundation

/*
 [{"key":"americanfootball_ncaaf","group":"American Football","title":"NCAAF","description":"US College Football","active":true,"has_outrights":false},
 */



struct Sport: Codable,Identifiable{
    var id: String {key}
    var key: String
    var group: String
    var title: String
    var description: String
    var active: Bool
    var has_outrights: Bool
    var events: [Event]
    
    
    static let sample = Sport(
        key: "americanfootball_ncaaf",
        group: "American Football",
        title: "NCAAF",
        description: "US College Football",
        active: true,
        has_outrights: false,
        events: [Event.sample]
    )
}


struct Event: Codable, Identifiable {
    var id: String
    var home_team: String
    var away_team: String
    var commence_time: String
    var odds: [Odds]
    
    static let sample = Event(
        id: "asdlaksjf",
        home_team: "Tottemham Hotspur",
        away_team: "Liverpool FC",
        commence_time: "2025-01-15T15:00:00Z",
        odds: [Odds.sample]
    )
    
    
    func mainOdds()->Odds?{
        var rOdds = odds.first
        
        for odd in odds{
            if odd.markets.count > rOdds!.markets.count{
                rOdds = odd
            }
        }
        
        return rOdds
    }
}

struct Odds: Codable, Identifiable{
    var id: String {bookmaker}
    var bookmaker: String
    var markets: [Market]
    
    
    static let sample = Odds(bookmaker: "Tipico", markets: [Market.h2h])
}

struct Market: Codable, Identifiable {
    var id : String{key}
    var key: String
    var outcomes: [Outcome]
    
    static let h2h = Market(key: "H2H", outcomes: [Outcome.sample,Outcome.sample2])
}

struct Outcome: Codable , Identifiable{
    var id : String {name}
    var name: String
    var price: Double
    var point: Double?
    
    static let sample = Outcome(name: "Home Win", price: 1.85, point: nil)
    static let sample2 = Outcome(name: "Away Win", price: 1.90, point: nil)
}

 


extension Sport{
    static let realSample = Sport(
        key: "soccer_germany_bundesliga",
        group: "Soccer",
        title: "Bundesliga - Germany",
        description: "German Soccer",
        active: true,
        has_outrights: false,
        events: [
            Event(
                id: "84ff7a4bd70183bf91e83e0490bee705",
                home_team: "VfL Wolfsburg",
                away_team: "Holstein Kiel",
                commence_time: "2025-01-24T19:30:00Z",
                odds: [
                    Odds(
                        bookmaker: "FanDuel",
                        markets: [
                            Market(
                                key: "h2h",
                                outcomes: [
                                    Outcome(name: "VfL Wolfsburg", price: 1.38, point: nil),
                                    Outcome(name: "Holstein Kiel", price: 6.5, point: nil),
                                    Outcome(name: "Draw", price: 4.8, point: nil)
                                ]
                            )
                        ]
                    ),
                    Odds(
                        bookmaker: "BetMGM",
                        markets: [
                            Market(
                                key: "h2h",
                                outcomes: [
                                    Outcome(name: "VfL Wolfsburg", price: 1.48, point: nil),
                                    Outcome(name: "Holstein Kiel", price: 6.25, point: nil),
                                    Outcome(name: "Draw", price: 4.6, point: nil)
                                ]
                            )
                        ]
                    )
                ]
            ),
            Event(
                id: "d0662ba5a92b369b21c9c020374c7b6a",
                home_team: "Augsburg",
                away_team: "1. FC Heidenheim",
                commence_time: "2025-01-25T14:30:00Z",
                odds: [
                    Odds(
                        bookmaker: "BetMGM",
                        markets: [
                            Market(
                                key: "h2h",
                                outcomes: [
                                    Outcome(name: "Augsburg", price: 1.91, point: nil),
                                    Outcome(name: "1. FC Heidenheim", price: 3.8, point: nil),
                                    Outcome(name: "Draw", price: 3.6, point: nil)
                                ]
                            )
                        ]
                    )
                ]
            ),
            Event(
                id: "b5179c84e19b311a7b499f1101b299aa",
                home_team: "Bayern Munich",
                away_team: "Holstein Kiel",
                commence_time: "2025-02-01T14:30:00Z",
                odds: [
                    Odds(
                        bookmaker: "Bovada",
                        markets: [
                            Market(
                                key: "h2h",
                                outcomes: [
                                    Outcome(name: "Bayern Munich", price: 1.05, point: nil),
                                    Outcome(name: "Holstein Kiel", price: 36, point: nil),
                                    Outcome(name: "Draw", price: 14, point: nil)
                                ]
                            ),
                            Market(
                                key: "spreads",
                                outcomes: [
                                    Outcome(name: "Bayern Munich", price: 1.89, point: -3.25),
                                    Outcome(name: "Holstein Kiel", price: 1.93, point: 3.25)
                                ]
                            ),
                            Market(
                                key: "totals",
                                outcomes: [
                                    Outcome(name: "Over", price: 1.85, point: 4.25),
                                    Outcome(name: "Under", price: 1.98, point: 4.25)
                                ]
                            )
                        ]
                    )
                ]
            )
        ]
    )

}
