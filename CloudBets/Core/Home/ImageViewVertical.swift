import SwiftUI

struct ImageViewVertical: View {
    
    var imageUrls: [String]

    var body: some View {
        TabView {
            ForEach(imageUrls, id: \.self) { url in
                ZStack {
                    Color.black.ignoresSafeArea() // 🔥 Schwarzer Hintergrund für bessere Darstellung

                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let loadedImage):
                            loadedImage
                                .resizable()
                                .scaledToFit() // 🔥 Passt das Bild an, ohne es zu beschneiden
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 🔥 Vertikales Scrollen ohne Indikatoren
        .ignoresSafeArea() // 🔥 Nutzt den ganzen Bildschirm
    }
}
