//
//  User.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import Foundation

class User: ObservableObject{
    
    let username: String
    
    init(username: String) {
        self.username = username
    }
    
}
