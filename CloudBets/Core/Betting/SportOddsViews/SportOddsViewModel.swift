import Foundation
import FirebaseFirestore

class SportOddsViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var groupedSports: [String: [Sport]] = [:]
    
    init() {
        fetchSports()
    }
    
    func fetchSports() {
        db.collection("NewSystem").getDocuments { snapshot, error in
            if let error = error {
                print("Fehler beim Abrufen der Daten: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("Keine Daten gefunden")
                return
            }

            DispatchQueue.main.async {
                // Konvertiere Dokumente in Sport-Objekte
                let sports = documents.compactMap { document -> Sport? in
                    do {
                        return try document.data(as: Sport.self)
                    } catch {
                        print("Fehler beim Dekodieren von \(document.documentID): \(error)")
                        return nil
                    }
                }
                
                print("Sportarten erfolgreich abgerufen: \(sports.count)")
                
                // Gruppiere die Sportarten
                self.groupSports(sports: sports)
            }
        }
    }
    
    private func groupSports(sports: [Sport]) {
        var groupedSports: [String: [Sport]] = [:]
        
        for sport in sports {
            if groupedSports[sport.group] == nil {
                groupedSports[sport.group] = [sport]
            } else {
                groupedSports[sport.group]?.append(sport)
            }
        }
        
        self.groupedSports = groupedSports
    }
}
