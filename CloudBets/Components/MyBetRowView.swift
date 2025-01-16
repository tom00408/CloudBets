import SwiftUI

struct MyBetRowView: View {
    let bet: Bet
    
    var body: some View {
        Text("ICH FISCKE EUCH")
    }
}

#Preview {
    MyBetRowView(
        bet: Bet(
            id: UUID(),
            userId: "LSKADMlsakmdlksad",
            stake: "100",
            odds: 2.5,
            legs: [Leg.sample, Leg.sample2]
        )
    ) // 🔥 Optimierte Vorschau
}
