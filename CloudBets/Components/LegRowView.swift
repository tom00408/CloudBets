import SwiftUI

struct LegRowView: View {
    
    let leg: Leg

    @EnvironmentObject var placeBetVM : PlaceBetViewModel

    var body: some View {
        ZStack(alignment: .topTrailing){
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(leg.homeTeam)")
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                    
                    
                    Text("\(leg.awayTeam)")
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                    
                    if let sportGroup = leg.sportGroup{
                        Text(sportGroup.uppercased())
                            .font(.subheadline)
                            .foregroundColor(CD.txt2)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(leg.market.uppercased())
                        .font(.caption)
                        .foregroundColor(CD.acc)
                    
                    Text(displayOutcome(outcomeName: leg.outcome))
                        .font(.headline)
                        .foregroundColor(CD.txt1)
                }
                
                VStack(spacing: 4) {
                    Text("Odds: \(leg.odds.toOddString())")
                        .font(.body)
                        .foregroundColor(CD.succes)
                    
                    if let points = leg.points {
                        Text("Points: \(points.toOddString())")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(CD.bg2)
                
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(CD.acc, lineWidth: 2)
                
            )
                
            /*
             Wette entfernen Button
             */
            Button{
                print("Wette wird entfernt")
                placeBetVM.removeLeg(leg: leg)
            }label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .foregroundColor(CD.acc)
                    .frame(width: 20, height: 20)
                    .padding(10)
                    
            }
                    
             
            
        }
        
        
    }
    
    func displayOutcome(outcomeName : String)->String{
        if let event = leg.event{
            if outcomeName == event.home_team{
                return "1"
            }
            if outcomeName == event.away_team{
                return "2"
            }
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
}

#Preview {
    LegRowView(leg: Leg.sample)
    LegRowView(leg: Leg.sample2)
}
