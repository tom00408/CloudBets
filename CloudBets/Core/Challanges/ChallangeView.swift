//
//  ChallangeView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 04.02.25.
//

import SwiftUI

struct ChallengeView: View {
    var body: some View {
        ZStack{
            CD.bg1.ignoresSafeArea()
            
            ScrollView{
                imageURLViewFeed(url: "https://firebasestorage.googleapis.com:443/v0/b/sportoddsapi.firebasestorage.app/o/news%2FLadderChallenge.png?alt=media&token=30810a8e-b1f7-4723-923e-2115b7754c0d" )
                imageURLViewFeed(url: "https://firebasestorage.googleapis.com:443/v0/b/sportoddsapi.firebasestorage.app/o/news%2FsurvivorChallenge.png?alt=media&token=777bf704-b36a-4eaa-b6c7-a10e15ee02ae")
            }
        }
            
    }
}

#Preview {
    ChallengeView()
}
