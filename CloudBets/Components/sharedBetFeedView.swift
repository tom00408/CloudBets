//
//  sharedBetFeedView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 04.02.25.
//

import SwiftUI

struct sharedBetFeedView: View {
    
    var bet: Bet
    
    var body: some View {
        MyBetRowView(bet: bet,interactive: true, showUser: true)
        
        
    }
}

