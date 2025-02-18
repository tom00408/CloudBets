//
//  AllEventsView().swift
//  CloudBets
//
//  Created by Tom Tiedtke on 21.01.25.
//

import SwiftUI

struct AllEventsView: View {
    
    var events: [Event]
    
    var body: some View {
        
        
            ZStack{
                
                CD.bg1
                    .ignoresSafeArea(.all)
                
                ScrollView{
                    ForEach(events, id: \.id){event in
                        VStack{
                            NavigationLink(
                                destination: EventView(event: event)) {
                                    EventRowView(event: event)
                                }.accentColor(.secondary)
                                .padding(.top, 10)
                            EventOddsRowView(event: event)
                        }.background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(CD.bg2)
                                
                        }
                        
                    }
                }.padding()
            }
        
        
    }
}

#Preview {
    AllEventsView(events: [Event.sample])
}
