import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var sportOddsVM : SportOddsViewModel
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    @Binding var showSignInView: Bool
    
    init(showSignInView: Binding<Bool>) {
        self._showSignInView = showSignInView
        
        // TabBar Hintergrund und Icon-Farben anpassen
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(CD.bg1)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(CD.txt2)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(CD.txt2)]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(CD.acc)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(CD.acc)]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            NavigationStack{
                HomeView()
                    .navigationTitle("Home")
                    .navigationBarHidden(true)
            }.tabItem{
                Label("Home",systemImage: "house")
            }
            NavigationStack {
                AllGroupsView(groupedSports: sportOddsVM.groupedSports)
                    .navigationTitle("Odds")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Label("Suche", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                PlaceBetView()
                    .navigationTitle("Wette plazieren")
                    .navigationBarHidden(true)
                    
            }
            .tabItem {
                Label("Wetten",systemImage: "plus.app")
            }


            .badge(placeBetVM.legs.count)
            
            
            NavigationStack{
                ChallengeView()
            }
            .tabItem {
                Label("Challenges",systemImage: "trophy")
            }
            
            
            NavigationStack {
                MyBetsView(showSignInView: $showSignInView)
                    .navigationTitle("Deine Wetten")
                    
            }
            .tabItem {
                Label("Meine Wetten", systemImage: "list.bullet.clipboard")
            }
            
            
           /*y
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
                    .navigationTitle("Profil")
                    .navigationBarTitleDisplayMode(.inline)
                    //.navigationBarHidden(true)
            }
            .tabItem {
                Label("Profil", systemImage: "person.circle")
            }*/
        }
        .accentColor(CD.acc) // Farbe für aktive Tabs und Inhalte
        .environment(\.horizontalSizeClass, .compact)
           
    }
}

#Preview {
    ContentView(showSignInView: .constant(false))
        .environmentObject(PlaceBetViewModel())
        .environmentObject(SportOddsViewModel())
}
