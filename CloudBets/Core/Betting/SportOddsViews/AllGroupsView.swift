import SwiftUI

struct AllGroupsView: View {
    
    @EnvironmentObject var sportOddsVM: SportOddsViewModel
    
    var groupedSports: [String:[Sport]]
    
    var body: some View {
        ZStack {
            CD.bg1
                .ignoresSafeArea(.all)
            
            ScrollView {
                ForEach(groupedSports.keys.sorted(), id: \.self) { group in
                    if let sports = groupedSports[group] {
                        NavigationLink(destination: AllSportsView(sports: sports)) {
                            GroupRowView(
                                group: group,
                                numberOfSports: sports.count
                            )
                            .accentColor(.primary)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .refreshable {
                sportOddsVM.fetchSports()
            }.accentColor(CD.acc)
            .padding()
        }
    }
}

#Preview {
    AllGroupsView(groupedSports:
                    ["Basketball" : [Sport.sample]]
    )
}
