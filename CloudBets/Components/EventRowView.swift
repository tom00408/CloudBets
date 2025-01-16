import SwiftUI

struct EventRowView: View {
    
    let event: Event
    
    var body: some View {
        VStack(spacing: 12) {
            Text(formattedDate(event.commence_time))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(CD.txt2)

            HStack {
                Spacer()
                Text(event.home_team)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(CD.txt1)
                Spacer()
                Text("vs")
                    .font(.title3)
                    .foregroundColor(CD.acc)
                Spacer()
                Text(event.away_team)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(CD.txt1)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(CD.bg3)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
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
    EventRowView(event: Event.sample)
}
