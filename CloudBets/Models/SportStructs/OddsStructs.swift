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
    var id: String
    var group: String
    var title: String
    var description: String
    var active: Bool
    var events: [Event]
    
    
    static let sample = Sport(
        id: "americanfootball_ncaaf",
        group: "American Football",
        title: "NCAAF",
        description: "US College Football",
        active: true,
        events: [Event.sample]
    )
}


struct Event: Codable, Identifiable {
    var id: String
    var homeTeam: String
    var awayTeam: String
    var startTime: String
    var bookmaker: Bookmaker
    
    enum CodingKeys: String, CodingKey {
        case id
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case startTime = "start_time"
        case bookmaker
    }
    
    static let sample = Event(
        id: "asdlaksjf",
        homeTeam: "Tottemham Hotspur",
        awayTeam: "Liverpool FC",
        startTime: "2025-01-15T15:00:00Z",
        bookmaker: Bookmaker.sample
    )
    
    
}

struct Bookmaker: Codable, Identifiable{
    var id: String {name}
    var name: String
    var markets: [Market]
    
    
    static let sample = Bookmaker(name: "Tipico", markets: [Market.h2h])
}

struct Market: Codable, Identifiable {
    var id : String{type}
    var type: String
    var outcomes: [Outcome]
    
    static let h2h = Market(type: "H2H", outcomes: [Outcome.sample,Outcome.sample2])
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
        id: "soccer_germany_bundesliga",
        group: "Soccer",
        title: "Bundesliga - Germany",
        description: "German Soccer",
        active: true,
        events: [
            Event(
                id: "84ff7a4bd70183bf91e83e0490bee705",
                homeTeam: "VfL Wolfsburg",
                awayTeam: "Holstein Kiel",
                startTime: "2025-01-24T19:30:00Z",
                bookmaker: Bookmaker(
                    name: "FanDuel",
                    markets: [
                        Market(
                            type: "H2H",
                            outcomes: [
                                Outcome(name: "VfL Wolfsburg", price: 1.38, point: nil),
                                Outcome(name: "Holstein Kiel", price: 6.5, point: nil),
                                Outcome(name: "Draw", price: 4.8, point: nil)
                            ]
                        )
                    ]
                )
            ),
            Event(
                id: "d0662ba5a92b369b21c9c020374c7b6a",
                homeTeam: "Augsburg",
                awayTeam: "1. FC Heidenheim",
                startTime: "2025-01-25T14:30:00Z",
                bookmaker: Bookmaker(
                    name: "BetMGM",
                    markets: [
                        Market(
                            type: "H2H",
                            outcomes: [
                                Outcome(name: "Augsburg", price: 1.91, point: nil),
                                Outcome(name: "1. FC Heidenheim", price: 3.8, point: nil),
                                Outcome(name: "Draw", price: 3.6, point: nil)
                            ]
                        )
                    ]
                )
            ),
            Event(
                id: "b5179c84e19b311a7b499f1101b299aa",
                homeTeam: "Bayern Munich",
                awayTeam: "Holstein Kiel",
                startTime: "2025-02-01T14:30:00Z",
                bookmaker: Bookmaker(
                    name: "Bovada",
                    markets: [
                        Market(
                            type: "H2H",
                            outcomes: [
                                Outcome(name: "Bayern Munich", price: 1.05, point: nil),
                                Outcome(name: "Holstein Kiel", price: 36, point: nil),
                                Outcome(name: "Draw", price: 14, point: nil)
                            ]
                        ),
                        Market(
                            type: "spreads",
                            outcomes: [
                                Outcome(name: "Bayern Munich", price: 1.89, point: -3.25),
                                Outcome(name: "Holstein Kiel", price: 1.93, point: 3.25)
                            ]
                        ),
                        Market(
                            type: "totals",
                            outcomes: [
                                Outcome(name: "Over", price: 1.85, point: 4.25),
                                Outcome(name: "Under", price: 1.98, point: 4.25)
                            ]
                        )
                    ]
                )
            )
        ]
    )
}
