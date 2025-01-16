//
//  UserManager.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 01.02.25.
//

import Foundation
import FirebaseFirestore


final class UserManager{
    
    static let shared = UserManager()
    private init(){}
    
    
    private let db = Firestore.firestore()
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    
    
    func createNewUser(user: DBUser)async throws{
        try userDocument(userId: user.userId)
            .setData(from: user, merge: false, encoder: encoder)
    }
    
    
    func getUser(userId: String)async throws -> DBUser{
        try await userDocument(userId: userId)
            .getDocument(as: DBUser.self, decoder: decoder)
    }
     

    
    func updateUser(user: DBUser)async throws{
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
    
    func updateUserPremium(userId: String, isPremium: Bool)async throws{
        try await userDocument(userId: userId).updateData(["is_premium" : isPremium])
    }
    
    func setUsername(userId: String, newUsername: String)async throws{
        try await userDocument(userId: userId).updateData(["username" : newUsername])
    }
    
}

//MARK: placeBetVM
extension UserManager {
    
    func uploadPlacedBet(userId: String, bet: Bet)async throws{
    //    try await userDocument(userId: userId).setData(<#T##documentData: [String : Any]##[String : Any]#>)
    }
    
}
