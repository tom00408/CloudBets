import FirebaseFirestore


public class EventManager: ObservableObject {
    static let shared = EventManager()
    private init() {}

    private let db = Firestore.firestore()

    /// Holt ein Event aus Firestore basierend auf `eventId`
    func getEvent(eventId: String) async throws -> Event {
        let query = db.collection("NewSystem")

        do {
            // Firestore-Abfrage mit `eventId`-Filter
            let snapshot = try await query
                .whereField("id", isEqualTo: eventId)
                .getDocuments()

            // Überprüfe, ob Dokumente vorhanden sind
            guard let document = snapshot.documents.first else {
                throw NSError(
                    domain: "",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Event nicht gefunden"]
                )
            }

            // Decodiere das Dokument in ein `Event`-Objekt
            return try document.data(as: Event.self)
        } catch {
            print("❌ Fehler beim Abrufen oder Decodieren des Events: \(error.localizedDescription)")
            throw error
        }
    }
}
