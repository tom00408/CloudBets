//
//  AllSportsView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 21.01.25.
//

import SwiftUI

struct AllSportsView: View {
    
    var sports : [Sport]
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                
                CD.bg1
                    .ignoresSafeArea(.all)
                
                ScrollView{
                    ForEach (sports) { sport in
                        NavigationLink(destination: AllEventsView(events: sport.events)) {
                            SportRowView(sport: sport)
                        }
                        .accentColor(.primary)
                        .cornerRadius(8)
                        
                    }
                }.padding()
            }
        }
        
    }
}

#Preview {
    AllSportsView(sports: [Sport.sample])
}
