//
//  Token.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 04.02.25.
//

import Foundation

struct Token : Codable, Hashable{
    let type: String
    let symbol : String
    let description : String?
    
    
}

extension Token{
    
    static let ladderToken = Token(type: "ladderTicket", symbol: "🪜", description: "1 Free ladder Token")
    static let OnexToken = Token(type: "1x", symbol: "1️⃣", description: "1x Unit")
    static let rebetToken = Token(type: "rebet", symbol: "🔁", description: "Rebet Unit")
    
    
    static let tokenFinder :  [String: Token] = [
        "ladderTicket" : ladderToken,
        "1x" : OnexToken,
        "rebet" : rebetToken
        
    ]
    
}
