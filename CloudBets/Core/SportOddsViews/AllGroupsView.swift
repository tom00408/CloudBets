//
//  AllGroupsView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 21.01.25.
//

import SwiftUI

struct AllGroupsView: View {
    
    var groupedSports: [String:[Sport]]
  
    
    var body: some View {
        
        
        NavigationStack{
            ZStack{
                
                CD.bg1
                    .ignoresSafeArea(.all)
                
                ScrollView{
                    ForEach(groupedSports.keys.sorted(), id: \.self){group in
                        
                        if let sports = groupedSports[group]{
                            NavigationLink(
                                destination: AllSportsView(sports: sports )
                            ) {
                                GroupRowView(
                                    group: group,
                                    numberOfSports:sports.count
                                )
                                .accentColor(.primary)
                                .cornerRadius(8)
                            }
                        }
                        
                    }
                }.padding()
            }
           
        
            
        }.navigationTitle("Sportarten")
        
    }
}

#Preview {
    AllGroupsView(groupedSports:
                    ["Basketball" : [Sport.sample]]
    )
}
