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
    
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        
        self.username = "user_"+Date().description
        self.bets = []
        
        self.xp = 0
    }
    
   
    
   
    
}
