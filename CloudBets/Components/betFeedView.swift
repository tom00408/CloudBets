//
//  betFeedView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 04.02.25.
//

import SwiftUI

struct betFeedView: View {
    var event : Event
    var market: Market
    var body: some View {
        VStack{
            EventRowView(event: event)
            SpecialEventOddsRowView(event: event, market: market)
        }.background(CD.bg3)
        .cornerRadius(10)
    }
}

#Preview {
    //betFeedView(event: .sample)
}
