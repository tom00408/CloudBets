import Foundation
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var trollImageUrls: [String] = []
    @Published var newsImageUrls: [String] = []
    @Published var matchesImageUrls: [String] = []
    
    @Published var events: [Event] = []
    @Published var bets: [Bet] = []
    
    @Published var items: [AnyView] = []    // ✅ Gemischte Views
   
    
    init() {
        Task {
            await loadImages()
            let fetchedEvents = await fetchEvents()
            let fetchedBets = await fetchBets()
            
            DispatchQueue.main.async {
                self.events = fetchedEvents // **Aktualisierung auf dem Hauptthread**
                self.bets = fetchedBets
                self.shuffleItems()
            }
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
                print(url)
                imageUrls.append(url.absoluteString)
            }
        } catch {
            print("❌ Fehler beim Abrufen der Bilder: \(error.localizedDescription)")
        }

        return imageUrls
    }

    
    //MARK: SHUFFLER
    func shuffleItems() {
        let urls = getAllUrls().map { url in
            AnyView(imageURLViewFeed(url: url))
        }

        let additionalViews: [AnyView] = events.flatMap { event in
            event.bookmaker.markets.map { market in
                AnyView(betFeedView(event: event, market: market))
            }
        }
        let betFeedViews : [AnyView] = bets.map { bet in
            AnyView(sharedBetFeedView(bet: bet))
        }


        items = (urls + additionalViews + betFeedViews).shuffled()
    }
}










// MARK: - Firestore: Event-IDs abrufen und Events laden
extension HomeViewModel {
    
    /// Lädt Event-IDs aus der Firestore-Collection und gibt eine Liste von Events zurück.
    func fetchEvents() async -> [Event] {
        let db = Firestore.firestore()
        let featuredCollection = db.collection("featuredEvents")
        let eventsCollection = db.collection("Quoten")
        
        do {
            // 1️⃣ IDs aus der Collection `featuredEvents` abrufen
            let snapshot = try await featuredCollection.getDocuments()
            let ids = snapshot.documents.compactMap { $0["eventId"] as? String }
            print("🔍 Gefundene Event-IDs: \(ids.count) --> \(String(describing: ids.first))")
            
            if ids.isEmpty {
                print("⚠️ Keine Event-IDs gefunden.")
                return []
            }
            
            // 2️⃣ Events basierend auf den IDs aus `NewSystem` abrufen
            var fetchedEvents: [Event] = []
            try await withThrowingTaskGroup(of: [Event].self) { group in
                for id in ids {
                    group.addTask {
                        do {
                            // Abfrage aller Dokumente aus `NewSystem`
                            let querySnapshot = try await eventsCollection.getDocuments()
                            let data = querySnapshot.documents
                            var localEvents: [Event] = []
                            
                            for x in data {
                                // Hole das `events`-Feld aus dem Dokument
                                guard let eventsArray = x.get("events") as? [[String: Any]] else {
                                    print("⚠️ Keine `events` im Dokument: \(x.documentID)")
                                    continue
                                }
                                
                                // Iteriere über jedes Event im Array
                                for eventDict in eventsArray {
                                    if let eventId = eventDict["id"] as? String, eventId == id {
                                        do {
                                            // Konvertiere das Dictionary in JSON-Daten
                                            let jsonData = try JSONSerialization.data(withJSONObject: eventDict, options: [])
                                            
                                            // Dekodiere die JSON-Daten in ein Event-Objekt
                                            let event = try JSONDecoder().decode(Event.self, from: jsonData)
                                            localEvents.append(event)
                                            print("✅ Event gefunden: \(event)")
                                        } catch {
                                            print("❌ Fehler beim Dekodieren des Events: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                            
                            return localEvents
                        } catch {
                            print("⚠️ Fehler beim Abrufen von Event \(id): \(error.localizedDescription)")
                            return []
                        }
                    }
                }
                
                // Sammle die Ergebnisse aller Tasks
                for try await localEvents in group {
                    fetchedEvents.append(contentsOf: localEvents)
                }
            }
            
            // 3️⃣ Events zurückgeben
            print("🎯 Erfolgreich \(fetchedEvents.count) Events geladen.")
            return fetchedEvents
        } catch {
            print("❌ Fehler beim Abrufen der Events: \(error.localizedDescription)")
            return []
        }
    }
    
    

    func fetchBets() async -> [Bet] {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        
        guard let userId = try? await UserManager.shared.getAuthenticatedUser()?.userId else {
            print("❌ Kein authentifizierter Benutzer gefunden")
            return []
        }


        let userDocRef = collection.document(userId)
        
        do {
            // 1️⃣ Firestore-Dokument abrufen
            let snapshot = try await userDocRef.getDocument()
            
            // 2️⃣ Überprüfen, ob das Dokument existiert und `bets` enthält
            guard let data = snapshot.data(), let betsArray = data["bets"] as? [[String: Any]] else {
                print("⚠️ Keine Bets gefunden für Benutzer \(userId)")
                return []
            }
            
            // 3️⃣ Bets aus Dictionaries in `Bet`-Objekte umwandeln
            var bets: [Bet] = betsArray.compactMap { betDict in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: betDict, options: [])
                    return try JSONDecoder().decode(Bet.self, from: jsonData)
                } catch {
                    print("❌ Fehler beim Dekodieren eines Bets: \(error.localizedDescription)")
                    return nil
                }
            }
            for bet in bets{
                if bet.legs.count > 5{
                    bets.removeAll(where: { $0.id == bet.id })
                }
            }
            print("✅ Erfolgreich \(bets.count) Bets geladen.")
            return bets
        } catch {
            print("❌ Fehler beim Abrufen der Bets: \(error.localizedDescription)")
            return []
        }
    }

    
    
    
}
