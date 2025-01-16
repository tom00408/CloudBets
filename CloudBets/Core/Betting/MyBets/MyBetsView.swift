//
//  MyBetsView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import SwiftUI

struct MyBetsView: View {
    var body: some View {
        ZStack{
            CD.bg1
                .ignoresSafeArea()
            VStack{
                Text("Deine Wetten werden hier angezeigt")
                    .foregroundColor(CD.acc)
            }
            
        }
        
    }
}

#Preview {
    MyBetsView()
}
