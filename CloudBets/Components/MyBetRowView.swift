import SwiftUI

struct MyBetRowView: View {
    @State var bet: Bet
    let interactive : Bool
    let showUser : Bool
    @State private var animateLock = false
    @State private var animateRebet = false
    @State private var lockClicked = false
    @State private var rebetClicked = false
    
    @State private var user: DBUser? = nil
    
    var body: some View {
        VStack{
            // **USER**
            if showUser{
                if let user = user {
                    HStack{
                        if let ppURL = user.photoUrl {
                            AsyncImage(url: URL(string: ppURL)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(CD.acc, lineWidth: 2)
                                    )
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text("\(user.username)")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(CD.acc)
                        Spacer()
                        Text("\(user.xp)")
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundColor(CD.acc2)
                        
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                        
                    }
                }
            }
            
            
            
            HStack{
            Text("\(bet.status)")
                .fontWeight(.bold)
                .foregroundColor(
                    bet.status == "pending" ? CD.warning : bet.status == "won" ? CD.success
                    : CD.error)
                .font(.system(size: 9))
                .padding(4)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(CD.acc, lineWidth: 2)
                }
            
                Text("\(bet.id)")
                    .foregroundColor(CD.txt2)
                    .font(.system(size: 10))
            }
            ForEach(bet.legs, id: \.id){leg in
                MyLegRowView(leg: leg)
            }
            /*
             Quote, Einsatz, (Auszahlung)
             */
            VStack{
                HStack(spacing: 16) {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Quote")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                        Text(bet.legs.isEmpty ? "---" : "\(bet.odds, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(CD.warning)
                    }
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Einsatz")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                        Text("\(bet.getEmoji(string: bet.stake))")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }
                    
                    Spacer()
                    if let stakeValue = Double(bet.stake){
                        VStack(spacing: 4) {
                            Text("Auszahlung")
                                .font(.caption)
                                .foregroundColor(CD.txt2)
                            Text(bet.legs.isEmpty ? "---" : "\(bet.odds * stakeValue, specifier: "%.2f")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(CD.success)
                        }
                        Spacer()
                    }
                }
                
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(CD.bg2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(CD.acc2, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            HStack{
                Spacer()
                Button{
                    if interactive{
                        lockClicked = true
                        let newLockCount = bet.locks + 1
                        bet.locks = newLockCount
                        withAnimation(.easeInOut(duration: 0.3)) {
                            animateLock = true
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                animateLock = false
                                
                            }
                        }
                        if let userId = bet.userId {
                            Task {
                                do {
                                    try await UserManager.shared.updateReactionsForBet(
                                        userId: userId,
                                        betId: bet.id,
                                        newLockCount: newLockCount,
                                        reaction: "locks"
                                    )
                                    
                                    print("✅ Lock erfolgreich aktualisiert für Bet: \(bet.id)")
                                } catch {
                                    print("❌ Fehler beim Aktualisieren der Locks: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }label:{
                    Text("\(bet.locks)🔒")
                        .padding(4)
                        .foregroundColor(CD.txt1)
                        .background(CD.acc.opacity(lockClicked ? 1 : 0.5))
                        .cornerRadius(8)
                        .animation(.easeInOut(duration: 0.3), value: bet.locks)
                        .scaleEffect(animateLock ? 1.4 : 1.0)
                }.disabled(lockClicked)
                Spacer()
                Button{
                    if interactive{
                        let newRebetCount = bet.reBets + 1
                        
                        if let userId = bet.userId{
                            Task{
                                do{
                                    let worked = try await UserManager.shared
                                        .updateReactionsForBet(
                                            userId: userId,
                                            betId: bet.id,
                                            newLockCount: newRebetCount,
                                            reaction: "reBets"
                                        )
                                    if worked{
                                        bet.reBets = newRebetCount
                                    }
                                    rebetClicked = worked
                                }
                            }
                        }
                        

                        withAnimation(.easeInOut(duration: 0.3)) {
                            animateRebet = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            withAnimation {
                                animateRebet = false
                                
                            }
                        }
                        
                        
                    }
                }label:{
                    Text("\(bet.reBets)🔁")
                        .padding(4)
                        .foregroundColor(CD.txt1)
                        .background(CD.acc.opacity(rebetClicked ? 1 : 0.5))
                        .cornerRadius(8)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: bet.reBets
                        )
                        .scaleEffect(animateRebet ? 1.4 : 1.0)
                }.disabled(rebetClicked)
                Spacer()
            }
            
            
            
        }.padding()
            .background(interactive ? CD.acc.opacity(0.6) : CD.bg3 )
            .cornerRadius(24)
            .onAppear{
                Task{
                    user = try await UserManager.shared
                        .getUser(userId: bet.userId ?? "nil")
                }
            }
    }
}

#Preview {
    MyBetRowView(
        bet: Bet(
            userId: "LSKADMlsakmdlksad",
            stake: "1",
            odds: 2.5,
            legs: [Leg.sample, Leg.sample2]
        
        ),
        interactive: false,
        showUser: true
    ) // 🔥 Optimierte Vorschau
}
