//
//  DBUser.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 02.02.25.
//

import Foundation

struct DBUser: Codable{
    
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    
    var username: String
    var bets: [Bet]
    
    
    var xp: Int
    var tokens: [String: Int]
    
    
    /*
     Erstes Mal erstellen
     */
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        
        self.username = "user"
        self.bets = []
        
        self.xp = 0
        self.tokens = [:]
    }
    
    /*
     Aus DB laden
     */
    enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case email
            case photoUrl = "photo_url"
            case dateCreated = "date_created"
            case username
            case bets
            case xp
            case tokens
            
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userId = try container.decode(String.self, forKey: .userId)
            email = try container.decodeIfPresent(String.self, forKey: .email)
            photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
            dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
            username = try container.decode(String.self, forKey: .username)
            bets = try container.decodeIfPresent([Bet].self, forKey: .bets) ?? []
            xp = try container.decode(Int.self, forKey: .xp)
            tokens = try container.decodeIfPresent([String:Int].self, forKey: .tokens) ?? [:]
            
        }
   
    
   
    
}
