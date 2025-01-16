import SwiftUI

struct EventView: View {
    let event: Event

    var body: some View {
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
                        .fill(CD.bg2)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )

                // Odds Section
                
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.bookmaker.name)
                            .font(.headline)
                            .foregroundColor(CD.txt1)
                            .padding(.bottom, 4)

                        ForEach(event.bookmaker.markets, id: \.id) { market in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Market: \(market.type)")
                                    .font(.subheadline)
                                    .foregroundColor(CD.txt2)

                                ForEach(market.outcomes, id: \.id) { outcome in
                                    HStack {
                                        Text(outcome.name)
                                            .font(.body)
                                            .foregroundColor(CD.txt1)

                                        Spacer()

                                        Text(String(format: "%.2f", outcome.price))
                                            .font(.body)
                                            .foregroundColor(CD.success)

                                        if let point = outcome.point {
                                            Text("Point: \(String(format: "%.1f", point))")
                                                .font(.footnote)
                                                .foregroundColor(CD.txt2)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(CD.bg3)
                                    )
                                }
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.bg2)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                
            }
            .padding()
        }
        .background(CD.bg1.ignoresSafeArea())
    }

    
}

#Preview {
    EventView(event: Event.sample)
}
