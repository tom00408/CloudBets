import SwiftUI

struct ImageViewHorizontal: View {
    
    var imageUrls: [String]

    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(imageUrls, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Lade-Spinner
                        case .success(let loadedImage):
                            loadedImage
                                .resizable()
                                .scaledToFit() // 🔥 Verhindert Cropping, zeigt das gesamte Bild
                                .frame(width: geometry.size.width * 0.901) // 🔥 85% der Breite für Sichtbarkeit des nächsten Bildes
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.90)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always)) // 🔥 Snapping mit Seiten-Indikator
            .indexViewStyle(.page(backgroundDisplayMode: .interactive)) // 🔥 Kleiner Punkt-Indikator unten
        }
        .frame(height: getDynamicHeight()) // 🔥 Dynamische Höhe für verschiedene Geräte
    }
    
    /// Berechnet die Höhe für iPhone & iPad dynamisch
    private func getDynamicHeight() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.height * 0.6 // 🔥 60% des iPad-Screens
        } else {
            return UIScreen.main.bounds.height * 0.5 // 🔥 40% des iPhone-Screens
        }
    }
}
