//
//  Terror.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 01.02.25.
//

import Foundation

enum Terror: Error , LocalizedError{
    
    case noIdToken
    case topVCNotFound
    
    case authError(String)
    
    case firestoreError(String)
    
    var errorDescription: String? {
        switch self {
        case .noIdToken:
            return "No idToken found (vermutlich bei GoogleSignIn)"
        case .topVCNotFound:
            return "TopViewController not found"
        case .authError(let message):
            return "Auth Error: \(message)"
        case .firestoreError(let message):
            return "Firestore Error: \(message)"
        }
    }
}

