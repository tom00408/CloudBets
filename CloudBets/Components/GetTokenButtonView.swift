//
//  GetTokenButtonView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 05.02.25.
//

import SwiftUI

struct GetTokenButtonView: View {
    
    let token: Token
    
    var body: some View {
        Button{
            Task {
                if let user = try await UserManager.shared.getAuthenticatedUser(){
                    
                    var tokens = user.tokens
                    
                    if let i = tokens[token.type]{
                        tokens[token.type] = i + 1
                    }else
                    {
                        tokens[token.type] = 1
                    }
                    
                    print("Tokens werden versucht hinzuzuzuzuzufügen: \(tokens)")
                    
                    try await UserManager.shared
                        .updateUserTokens(
                            userId: user.userId,
                            tokens: tokens
                        )
                }else{
                    print("User nicht geladen...Kein Mysterie Token")
                }
            }
        }label:{
            HStack{
                Text("Add mysterie Token \(token.symbol)")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
            }.background(CD.acc)
                .padding()
                .cornerRadius(24)
        }
    }
}

#Preview {
    GetTokenButtonView(token: Token.ladderToken)
}
