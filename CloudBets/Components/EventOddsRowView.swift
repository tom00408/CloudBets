//
//  EventOddsRowView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 23.01.25.
//

import SwiftUI

struct EventOddsRowView: View {
    
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    
    let event: Event
    
    var body: some View {
        
        if let mainOdds = event.mainOdds(){
            if let firstOdds = mainOdds.markets.first {
                HStack() { // Abstand zwischen den Outcomes
                    Spacer()
                    ForEach(firstOdds.outcomes.sorted(by: sortOutcomes), id: \.id) { outcome in
                        Button{
                            print("\(outcome.name) \(outcome.price) \(firstOdds.key)")
                            
                            let leg = Leg(
                                event: event,
                                homeTeam: event.home_team,
                                awayTeam: event.away_team,
                                market: firstOdds.key,
                                outcome: outcome.name,
                                odds: outcome.price,
                                points: outcome.point,
                                sportGroup: nil
                            )
                            
                            placeBetVM.selectLeg(leg: leg)
                        }label: {
                            
                            
                            HStack() {
                                Text("\(displayOutcome(outcomeName: outcome.name))") // Kurze Namen
                                    .font(.headline)
                                    .foregroundColor(CD.txt1)
                                
                                Text(outcome.price.toOddString()) // Prominente Quoten
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(CD.succes)
                                
                                if let point = outcome.point {
                                    Text(point.toOddString()) // Blassere Punkte
                                        .font(.caption)
                                        .foregroundColor(CD.txt2)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(CD.bg3) // Heller Hintergrund für die Box
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(CD.acc, lineWidth: 1) // Rahmen
                            )
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CD.bg2) // Abgesetzter Hintergrund für die gesamte Zeile
                )
                .padding(.horizontal)
            }
        }
    }
    
    func displayOutcome(outcomeName : String)->String{
        if outcomeName == event.home_team{
            return "1"
        }
        if outcomeName == event.away_team{
            return "2"
        }
        if outcomeName == "Draw"{
            return "X"
        }
        if outcomeName == "Over"{
            return "+"
        }
        if outcomeName == "Under"{
            return "-"
        }
        
        
        return outcomeName
    }
    
    func sortOutcomes(lhs: Outcome, rhs: Outcome) -> Bool {
        let order: [String: Int] = [
            event.home_team: 0, // Heimteam
            "Draw": 1,          // Unentschieden
            event.away_team: 2, // Auswärtsteam
            "Over": 3,          // Over
            "Under": 4          // Under
        ]
        
        let lhsRank = order[lhs.name] ?? Int.max
        let rhsRank = order[rhs.name] ?? Int.max
        
        return lhsRank < rhsRank
    }

}

#Preview {
    EventOddsRowView(event : Sport.realSample.events.first!)
}
