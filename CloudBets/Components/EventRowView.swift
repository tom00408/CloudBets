import SwiftUI

struct EventRowView: View {
    
    let event: Event
    
    var body: some View {
        VStack(spacing: 12) {
            Text(
                Utilities.shared.formattedDate(event.startTime)
            )
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(CD.txt2)

            HStack {
                Spacer()
                Text(event.homeTeam)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(CD.txt1)
                Spacer()
                Text("vs")
                    .font(.title3)
                    .foregroundColor(CD.acc)
                Spacer()
                Text(event.awayTeam)
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
    
    
    
    
}

#Preview {
    EventRowView(event: Event.sample)
}
