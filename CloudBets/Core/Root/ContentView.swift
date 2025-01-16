//
//  ContentView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 16.01.25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = SportOddsViewModel()
    @EnvironmentObject var placeBetVM: PlaceBetViewModel
    
    init() {
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
               AllGroupsView(groupedSports: vm.groupedSports)
                   .tabItem {
                       Label("odds", systemImage: "book.pages")
                   }
               
               PlaceBetView()
                   .tabItem {
                       Label(
                        "wette placen ",
                        systemImage: "plus.app"
                       )
                   }.badge(placeBetVM.legs.count)
               
               MyBetsView()
                   .tabItem {
                       Label("meine Wetten", systemImage: "list.bullet.clipboard")
                   }
           }
           .accentColor(CD.acc) // Farbe für aktive Tabs und Inhalte
       }
}

#Preview {
    ContentView()
        .environmentObject(PlaceBetViewModel())
}
