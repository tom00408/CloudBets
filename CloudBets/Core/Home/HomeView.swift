//
//  HomeView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 03.02.25.
//

import SwiftUI




struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            CD.bg1
                .ignoresSafeArea()
            //Home Feed
            ScrollView{
                VStack{
                    Text("Feed")
                        .foregroundColor(CD.acc)
                    
                    ForEach(Array(viewModel.items.enumerated()), id: \.offset) { _, view in
                        view
                    }
                    
                    
                }
            }.refreshable {
                await viewModel.loadImages()   // Bilder neu laden
                let newEvents = await viewModel.fetchEvents()  // Events neu laden
                let newBets = await viewModel.fetchBets()      // Wetten neu laden
                
                DispatchQueue.main.async {
                    viewModel.events = newEvents
                    viewModel.bets = newBets
                    viewModel.shuffleItems()  // UI-Elemente neu mischen
                }
            }
        }
    }
}
    
    #Preview {
        HomeView()
    }
