import SwiftUI

struct PlaceBetView: View {
    
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    
    @State private var choosingStake: Bool = false
    @State private var stakeOptions: [String] = ["Leiter", "1", "2", "5"]
    
    var body: some View {
        ZStack {
            CD.bg1.ignoresSafeArea(.all) // Hintergrund
            
            VStack {
                ScrollView {
                    Text("Dein Wettschein")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(CD.acc)
                    
                    /*
                     Leg Rows
                     */
                    ForEach(placeBetVM.legs, id: \.id) { leg in
                        LegRowView(leg: leg)
                    }
                    
                    if placeBetVM.legs.isEmpty {
                        Text("Noch keine Auswahlen getroffen")
                            .foregroundColor(CD.acc)
                            .padding(.top, 280)
                    }
                }
                .onTapGesture {
                    choosingStake = false
                }
                
                /*
                 Choosing Stake - ScrollView sollte eine feste Höhe haben!
                 */
                if choosingStake {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(stakeOptions, id: \.self) { stake in
                                Button {
                                    placeBetVM.setStake(stake: stake)
                                    choosingStake = false
                                } label: {
                                    Text("\(placeBetVM.getEmoji(string: stake))")
                                        .foregroundColor(CD.txt1)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(CD.txt1, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50) // 🔥 Fix: Damit die Stake-Auswahl richtig angezeigt wird
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.bg2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CD.acc, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                
                /*
                 Gesamtquote und Einsatz
                 */
                HStack(spacing: 16) {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Gesamtquote")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                        Text(placeBetVM.legs.isEmpty ? "---" : "\(placeBetVM.price, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }
                    Spacer()
                    Button {
                        choosingStake.toggle()
                    } label: {
                        VStack(spacing: 4) {
                            Text("Einsatz")
                                .font(.caption)
                                .foregroundColor(CD.txt2)
                            Text("\(placeBetVM.getEmoji(string: placeBetVM.stake))")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(CD.txt1)
                        }
                    }
                    Spacer()
                    if let stakeValue = Double(placeBetVM.stake){
                        VStack(spacing: 4) {
                            Text("Auszahlung")
                                .font(.caption)
                                .foregroundColor(CD.txt2)
                            Text(placeBetVM.legs.isEmpty ? "---" : "\(placeBetVM.price * stakeValue, specifier: "%.2f")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(CD.txt1)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CD.bg2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(CD.acc, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .onTapGesture {
                    choosingStake = false
                }
                
                /*
                 Wette abgeben Knopf
                 */
                Button {
                    print("Place Bet")
                    
                    Task{
                        await placeBetVM.placeBet()
                    }
                } label: {
                    HStack {
                        Text("Wette abgeben")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(CD.txt1)
                        Image(systemName: "chevron.right")
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }
                    .padding()
                    .frame(width: 250, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.acc.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CD.acc.opacity(0.8), lineWidth: 2)
                    )
                }
                .opacity(placeBetVM.isBetValid && !choosingStake ? 1 : 0.3)
                .disabled(!placeBetVM.isBetValid || choosingStake) // 🔥 Fix: Logik für Disabled-Funktion angepasst
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
        }.onAppear{
            Task {
                await placeBetVM.loadCurrentUser()
            }
        }
    }
}

#Preview {
    PlaceBetView()
        .environmentObject(PlaceBetViewModel())
}
