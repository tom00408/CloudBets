//
//  GroupRowView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 21.01.25.
//

import SwiftUI

struct GroupRowView: View {
    
    var group : String
    var numberOfSports : Int?
    
    var symbolname : String {
        switch group{
        case "Basketball":
            return "figure.basketball"
        case "American Football":
            return "figure.american.football"
        case "Cricket":
            return "figure.cricket"
        case "Boxing":
            return "figure.boxing"
        case "Aussie Rules":
            return "figure.rugby"
        case "Tennis":
            return "figure.tennis"
        case "Rugby League":
            return "figure.rugby"
        case "Ice Hockey":
            return "figure.ice.hockey"
        case "Soccer":
            return "figure.soccer"
        case "Mixed Martial Arts":
            return "figure.martial.arts"
        default:
            return "figure.run"
        
        }
    }
    
    var body: some View {
        
        HStack{
            Image(systemName: symbolname)
                .foregroundColor(CD.txt1)
            Spacer()
            Text(group)
                .fontWeight(.bold)
                .foregroundColor(CD.txt1)
            Spacer()
            if let num = numberOfSports{
                Text(String(num))
                    .fontWeight(.bold)
                    .foregroundColor(CD.txt1)
            }
        }
        .padding()
        .background(content: {
            RoundedRectangle(cornerRadius: 12)
                .fill(CD.bg2)
        })
        .overlay {
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(CD.acc, lineWidth: 2) // Rahmen mit Akzentfarbe
        }.shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Leichte Schatten
        
        
    }
}

#Preview {
    GroupRowView(group: "Basketball",numberOfSports: 4)
}
