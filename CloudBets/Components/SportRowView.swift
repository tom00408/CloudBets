//
//  SportRowView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 21.01.25.
//

import SwiftUI

struct SportRowView: View {
    
    let sport : Sport
    
    var body: some View {
        HStack {
            Image(systemName: "trophy")
                .font(.title)
                .foregroundColor(CD.acc)
                .padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(sport.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(CD.txt1)
                
                Text(sport.description)
                    .font(.subheadline)
                    .foregroundColor(CD.txt2)
            }
            
            Spacer()
            
            Text(String(sport.events.count))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(CD.success)
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(CD.bg2) // Dunkler Hintergrund
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Leichte Schatten
        )
        .padding(.horizontal)
    }

}

#Preview {
    SportRowView(sport: Sport.sample)
}
