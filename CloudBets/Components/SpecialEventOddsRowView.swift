//
//  EventOddsRowView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 23.01.25.
//

import SwiftUI

struct SpecialEventOddsRowView: View {
    
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    
    let event: Event
    let market: Market?
    
    var isSelected : Bool = true
    
    var body: some View {
        
        
        if let firstMarket = market {
                HStack() { // Abstand zwischen den Outcomes
                    Spacer()
                    ForEach(firstMarket.outcomes.sorted(by: sortOutcomes), id: \.id) { outcome in
                        
                        let leg = Leg(
                            eventId: event.id,
                            homeTeam: event.homeTeam,
                            awayTeam: event.awayTeam,
                            market: firstMarket.type,
                            outcome: outcome.name,
                            odds: outcome.price,
                            points: outcome.point,
                            sportGroup: nil,
                            status: BettingStatus.pending.rawValue
                        )
                        
                        Button{
                            if !placeBetVM.containsExactLeg(leg: leg){
                                print("\(outcome.name) \(outcome.price) \(firstMarket.type)")
                                placeBetVM.selectLeg(leg: leg)
                            }else{
                                print("REMOVING \(outcome.name) \(outcome.price) \(firstMarket.type)")
                                placeBetVM.removeLeg(leg: leg)
                            }
                            
                            
                        }label: {
                            
                            
                            HStack() {
                                Text("\(displayOutcome(outcomeName: outcome.name))") // Kurze Namen
                                    .font(.headline)
                                    .foregroundColor(CD.txt1) /// MAYBE HIER NUR WEISS ALSO BG1 RAUSNEHMEN
                                
                                Text(outcome.price.toOddString()) // Prominente Quoten
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(CD.success)
                                
                                if let point = outcome.point {
                                    Text("\(point > 0 && firstMarket.type ==  "spreads" ? "+" : "")\(point.toOddString())")
                                        .font(.caption)
                                        .foregroundColor(CD.txt2)
                                }

                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        placeBetVM
                                            .containsExactLeg(
                                                leg: leg
                                            ) ? CD.acc : CD.bg3
                                    ) // Heller Hintergrund für die Box
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
    
    func displayOutcome(outcomeName : String)->String{
        if outcomeName == event.homeTeam{
            return "1"
        }
        if outcomeName == event.awayTeam{
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
            event.homeTeam: 0, // Heimteam
            "Draw": 1,          // Unentschieden
            event.awayTeam: 2, // Auswärtsteam
            "Over": 3,          // Over
            "Under": 4          // Under
        ]
        
        let lhsRank = order[lhs.name] ?? Int.max
        let rhsRank = order[rhs.name] ?? Int.max
        
        return lhsRank < rhsRank
    }

}

#Preview {
    SpecialEventOddsRowView(
        event : Sport.realSample.events.first!,
        market: Event.sample.bookmaker.markets.first
    )
}
