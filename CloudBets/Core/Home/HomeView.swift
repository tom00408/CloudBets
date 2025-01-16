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
                    
                    
                    /*
                    news und upcoming matches Images
                     */
                    if !viewModel.newsImageUrls.isEmpty{
                        Text("News")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(CD.acc)
                        ImageViewHorizontal(imageUrls: viewModel.newsImageUrls)
                    }
                    if !viewModel.matchesImageUrls.isEmpty{
                        Text("Upcoming Matches") 
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(CD.acc)
                        ImageViewHorizontal(imageUrls: viewModel.matchesImageUrls)
                    }
                    /*
                    ForEach(viewModel.trollImageUrls, id: \.self) { url in
                        Text("Test")
                            .foregroundColor(CD.acc)
                        imageURLViewFeed(url: url)
                    }*/
                    Text("SHUFFLE")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(CD.acc)
                    
                    ForEach(viewModel.getAllUrls(), id: \.self) { url in
                        imageURLViewFeed(url: url)
                    }
                    
                    
                }
            }.refreshable {
                await viewModel.loadImages()
            }
        }
        
    }
}

#Preview {
    HomeView()
}
/*
struct ImageViewHorizontal: View{
    
    var imageUrls: [String]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(imageUrls, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Lade-Spinner
                        case .success(let loadedImage):
                            loadedImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 400)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
*/


