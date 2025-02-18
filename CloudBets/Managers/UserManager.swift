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
    
    /*private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()*/
    
    
    
    
    func createNewUser(user: DBUser)async throws{
        try userDocument(userId: user.userId)
            .setData(from: user, merge: false, encoder: encoder)
    }
    
    
    func getUser(userId: String)async throws -> DBUser{
        try await userDocument(userId: userId)
            .getDocument(as: DBUser.self)
    }
    
    func getAuthenticatedUser()async throws -> DBUser?{
        do{
            let authResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let user = try await getUser(userId: authResult.uid)
            return user
        }catch {
            print("Error loading user: \(error.localizedDescription)")
        }
        return nil
    }
     

    
    func updateUser(user: DBUser)async throws{
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
    
    func updateUserPremium(userId: String, isPremium: Bool)async throws{
        try await userDocument(userId: userId).updateData(["is_premium" : isPremium])
    }
    
    func updateUserTokens(userId: String, tokens: [String: Int]) async throws {
        try await userDocument(userId: userId).updateData([
            "tokens": tokens
        ])
        print("UserManger: Tokens updated: \(tokens)")
    }

    
    func updateReactionsForBet(userId: String, betId: String, newLockCount: Int, reaction: String) async throws -> Bool{
        
        if let currentUser = try await getAuthenticatedUser() {
            var tokens = currentUser.tokens // Erstelle eine Kopie der Tokens
            
            let currentReBets = tokens[Token.rebetToken.type] ?? 0
            
            // Prüfen, ob der User zu wenige Tokens hat UND "reBets" ausgewählt ist
            if currentReBets < 1 && reaction == "reBets" {
                print("Nicht genug ReBets vorhanden. Aktion wird abgebrochen.")
                return false
            }
            
            // Falls genug ReBets vorhanden sind, einen abziehen
            tokens[Token.rebetToken.type] = currentReBets - 1
            if currentReBets < 0 {
                tokens[Token.rebetToken.type] = 0
            }
            // Aktualisierte Tokens an den Server senden
            try await updateUserTokens(userId: currentUser.userId, tokens: tokens)

        } else {
            if reaction == "reBets" {
                print("Kein User gefunden, der ReBets geben kann.")
                return false
            }
        }


        
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
        
        do {
            // 1️⃣ Hole die Benutzerdaten
            let snapshot = try await userDocRef.getDocument()
            
            // Überprüfe, ob das Benutzer-Dokument existiert
            guard let userData = snapshot.data(),
                  var bets = userData["bets"] as? [[String: Any]] else {
                print("❌ Benutzer oder Bets nicht gefunden.")
                return false
            }
            
            // 2️⃣ Finde den entsprechenden Bet
            if let index = bets.firstIndex(where: { $0["id"] as? String == betId }) {
                // 3️⃣ Aktualisiere die Lock-Anzahl für den Bet
                bets[index][reaction] = newLockCount
                
                // 4️⃣ Speichere die aktualisierten Bets zurück in Firestore
                try await userDocRef.updateData([
                    "bets": bets
                ])
                
                print(
                    "✅ \(reaction) erfolgreich auf \(newLockCount) für Bet \(betId) aktualisiert."
                )
            } else {
                print("⚠️ Kein Bet mit der ID \(betId) gefunden.")
            }
        } catch {
            print(
                "❌ Fehler beim Aktualisieren der \(reaction): \(error.localizedDescription)"
            )
            throw error
        }
        return true
    }

    
    
    func setUsername(userId: String, newUsername: String)async throws{
        try await userDocument(userId: userId).updateData(["username" : newUsername])
    }
    
}

//MARK: placeBetVM

extension UserManager {
    
    func uploadPlacedBet(userId: String, bet: Bet) async throws {
        let userRef = userDocument(userId: userId)

        // Konvertiere `bet` in ein Dictionary für Firestore
        let betData: [String: Any] = [
            "id": bet.id,
            "userId": bet.userId ?? "",
            "stake": bet.stake,
            "odds": bet.odds,
            "status": bet.status,
            "locks": bet.locks,
            "reBets": bet.reBets,
            "legs": bet.legs.map { leg in
                return [
                    "id": leg.id,
                    "eventId": leg.eventId,
                    "homeTeam": leg.homeTeam,
                    "awayTeam": leg.awayTeam,
                    "market": leg.market,
                    "outcome": leg.outcome,
                    "odds": leg.odds,
                    "points": leg.points as Any,
                    "sportGroup": leg.sportGroup as Any,
                    "status": leg.status,
                    "score": leg.score != nil ? [
                        "id": leg.score!.id,
                        "home": leg.score!.home,
                        "away": leg.score!.away,
                        "last_update": leg.score!.last_update
                    ] : nil
                ].compactMapValues { $0 } // Entfernt `nil`-Werte
            }
        ]

        try await userRef.updateData([
            "bets": FieldValue.arrayUnion([betData])
        ])
    }
    
    
    
}

