import SwiftUI

struct EventView: View {
    let event: Event

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Event Header
                VStack(spacing: 8) {
                    Text(formattedDate(event.commence_time))
                        .font(.headline)
                        .foregroundColor(CD.txt2)

                    HStack {
                        Text(event.home_team)
                            .font(.title2)
                            .bold()
                            .foregroundColor(CD.txt1)

                        Text("vs")
                            .font(.title3)
                            .foregroundColor(CD.acc)

                        Text(event.away_team)
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
                ForEach(event.odds, id: \.id) { odd in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(odd.bookmaker)
                            .font(.headline)
                            .foregroundColor(CD.txt1)
                            .padding(.bottom, 4)

                        ForEach(odd.markets, id: \.id) { market in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Market: \(market.key)")
                                    .font(.subheadline)
                                    .foregroundColor(CD.txt2)

                                ForEach(market.outcomes, id: \.id) { outcome in
                                    HStack {
                                        Text(outcome.name)
                                            .font(.body)
                                            .foregroundColor(CD.txt1)

                                        Spacer()

                                        Text(String(format: "Price: %.2f", outcome.price))
                                            .font(.body)
                                            .foregroundColor(CD.succes)

                                        if let point = outcome.point {
                                            Text("Point: \(point)")
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
            }
            .padding()
        }
        .background(CD.bg1.edgesIgnoringSafeArea(.all))
    }

    // Helper to format ISO8601 date strings
    func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return "Invalid Date"
    }
}

#Preview {
    EventView(event: Event.sample)
}
