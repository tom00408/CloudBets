import SwiftUI

struct EventView: View {
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    let event: Event

    var body: some View {
        ZStack{
            CD.bg1.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Event Header
                    VStack(spacing: 8) {
                        Text(Utilities.shared.formattedDate(event.startTime))
                            .font(.headline)
                            .foregroundColor(CD.txt2)
                        
                        HStack {
                            Text(event.homeTeam)
                                .font(.title2)
                                .bold()
                                .foregroundColor(CD.txt1)
                            
                            Text("vs")
                                .font(.title3)
                                .foregroundColor(CD.acc)
                            
                            Text(event.awayTeam)
                                .font(.title2)
                                .bold()
                                .foregroundColor(CD.txt1)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.bg3)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    
                    // Odds Section
                    VStack{
                        ForEach(event.bookmaker.markets, id: \.id){ market in
                            VStack(alignment: .center, spacing: 12) {
                                Text(market.type)
                                    .font(.headline )
                                    .foregroundColor(CD.txt1)
                                    .padding(.bottom, 4)
                                
                                HStack(spacing: 12) {
                                    ForEach(market.outcomes.sorted(by: sortOutcomes), id: \.id) { outcome in
                                        let leg = Leg(
                                            eventId: event.id,
                                            homeTeam: event.homeTeam,
                                            awayTeam: event.awayTeam,
                                            market: market.type,
                                            outcome: outcome.name,
                                            odds: outcome.price,
                                            points: outcome.point,
                                            sportGroup: nil,
                                            status: BettingStatus.pending.rawValue
                                        )
                                        
                                        Button {
                                            if !placeBetVM.containsExactLeg(leg: leg) {
                                                placeBetVM.selectLeg(leg: leg)
                                            } else {
                                                placeBetVM.removeLeg(leg: leg)
                                            }
                                        } label: {
                                            HStack {
                                                Text(displayOutcome(outcomeName: outcome.name))
                                                    .font(.headline)
                                                    .foregroundColor(CD.txt1)
                                                
                                                Text(outcome.price.toOddString())
                                                    .font(.title3)
                                                    .bold()
                                                    .foregroundColor(CD.success)
                                                
                                                if let point = outcome.point {
                                                    Text("\(point > 0 && market.type == "spreads" ? "+" : "")\(point.toOddString())")
                                                        .font(.caption)
                                                        .foregroundColor(CD.txt2)
                                                }
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(
                                                        placeBetVM.containsExactLeg(leg: leg) ? CD.acc : CD.bg3
                                                    )
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(CD.acc, lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(CD.bg2)
                                )
                            }
                            .padding()
                        }
                    }.background(CD.bg3)
                        .cornerRadius(12)
                }
                .padding()
            }.toolbarBackgroundVisibility(Visibility.hidden, for: .navigationBar)
        }
    }

    func displayOutcome(outcomeName: String) -> String {
        switch outcomeName {
        case event.homeTeam: return "1"
        case event.awayTeam: return "2"
        case "Draw": return "X"
        case "Over": return "+"
        case "Under": return "-"
        default: return outcomeName
        }
    }

    func sortOutcomes(lhs: Outcome, rhs: Outcome) -> Bool {
        let order: [String: Int] = [
            event.homeTeam: 0,
            "Draw": 1,
            event.awayTeam: 2,
            "Over": 3,
            "Under": 4
        ]
        return (order[lhs.name] ?? Int.max) < (order[rhs.name] ?? Int.max)
    }
}

#Preview {
    EventView(event: Event.sample)
        .environmentObject(PlaceBetViewModel())
}
