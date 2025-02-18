import SwiftUI
import Firebase

@main
struct CloudBetsApp: App {
    
    @StateObject var placeBetViewModel = PlaceBetViewModel()
    @StateObject var sportOddsViewModel = SportOddsViewModel()
    
    init() {
        FirebaseApp.configure()
        print("✅ Firebase wurde erfolgreich initialisiert")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(placeBetViewModel) // Falls ViewModel in mehreren Views genutzt wird
                .environmentObject(sportOddsViewModel)
        }
    }
}
