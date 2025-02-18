import SwiftUI

struct MyLegRowView: View {
    
    let leg: Leg

    @EnvironmentObject var placeBetVM : PlaceBetViewModel

    var body: some View {
        ZStack(alignment: .topTrailing){
            
            VStack() {
                VStack(alignment: .center, spacing: 4) {
                    /*
                    Text("\(leg.homeTeam)")
                        .foregroundColor(CD.txt1)
                    */
                    
                    Text("\(leg.homeTeam) - \(leg.awayTeam)")
                        .foregroundColor(CD.txt1)
                    
                    HStack{
                        Text("\(leg.status)")
                            .foregroundColor(
                                leg.status == "pending" ? CD.warning : leg.status == "won" ? CD.success
                                : CD.error)
                            .font(.system(size: 9))
                            .padding(4)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(CD.txt1, lineWidth: 1)
                            }
                    }.opacity(0.6)
                    
                }//.frame(width: 200)
                
                //Spacer()
                HStack{
                    VStack(spacing: 4) {
                        Text(leg.market.uppercased())
                            .font(.caption)
                            .foregroundColor(CD.acc)
                        
                        Text(displayOutcome(outcomeName: leg.outcome))
                            .font(.headline)
                            .foregroundColor(CD.txt1)
                    }
                    
                    VStack(spacing: 4) {
                        Text("x\(leg.odds.toOddString())")
                            .font(.body)
                            .foregroundColor(CD.success)
                        
                        if let points = leg.points {
                            Text("Points: \(points.toOddString())")
                                .font(.caption)
                                .foregroundColor(CD.txt2)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(CD.bg2)
                
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(CD.acc, lineWidth: 2)
                
            )
             
             
            
        }
        
        
    }
    
    func displayOutcome(outcomeName : String)->String{
        
        if outcomeName == leg.homeTeam{
            return "1"
        }
        if outcomeName == leg.awayTeam{
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
}

#Preview {
    LegRowView(leg: Leg.sample)
    LegRowView(leg: Leg.sample2)
}
