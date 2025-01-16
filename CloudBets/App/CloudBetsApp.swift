//
//  CloudBetsApp.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 16.01.25.
//

import SwiftUI
import Firebase
@main
struct CloudBetsApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    @StateObject var user : User = User(username: "Tom")
    @StateObject var placeBetViewModel : PlaceBetViewModel = PlaceBetViewModel()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(placeBetViewModel)
            
        }
    }
}
