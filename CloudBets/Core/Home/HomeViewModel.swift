import Foundation
import FirebaseStorage

class HomeViewModel: ObservableObject {
    @Published var trollImageUrls: [String] = []
    @Published var newsImageUrls: [String] = []
    @Published var matchesImageUrls: [String] = []

    
    
    init() {
        Task {
            await loadImages() // 🔥 Lädt alle Bilder asynchron
        }
    }

    func getAllUrls() -> [String] {
        return (trollImageUrls + newsImageUrls + matchesImageUrls).shuffled()
    }
    
    /// Lädt alle Bilder für verschiedene Kategorien
    func loadImages() async {
        let trollImages = await fetchImages(file: "troll")
        let newsImages = await fetchImages(file: "news")
        let matchesImages = await fetchImages(file: "matches")

        DispatchQueue.main.async {
            self.trollImageUrls = trollImages
            self.newsImageUrls = newsImages
            self.matchesImageUrls = matchesImages
        }
    }

    /// Holt alle Bild-URLs aus Firebase Storage und gibt sie zurück
    func fetchImages(file: String) async -> [String] {
        let storageRef = Storage.storage().reference().child(file)
        var imageUrls: [String] = []

        do {
            let result = try await storageRef.listAll()
            for item in result.items {
                let url = try await item.downloadURL()
                imageUrls.append(url.absoluteString)
            }
        } catch {
            print("❌ Fehler beim Abrufen der Bilder: \(error.localizedDescription)")
        }

        return imageUrls
    }
}
