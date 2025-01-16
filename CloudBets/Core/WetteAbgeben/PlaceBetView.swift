//
//  PlaceBetView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 25.01.25.
//

import SwiftUI

struct PlaceBetView: View {
    
    @EnvironmentObject var placeBetVM : PlaceBetViewModel
    
    @State private var choosingStake : Bool = false
    @State private var stakeOptions: [Double] = [1,2,5,10,20,50,100,200,300]
    
    var body: some View {
        ZStack{
            
            CD.bg1
                .ignoresSafeArea(.all)
            VStack{
                ScrollView{
                    Text("Dein Wettschein")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(CD.acc)
                        
                    
                    /*
                     Leg Rows
                     */
                    ForEach(placeBetVM.legs, id: \.id) { leg in
                        LegRowView(leg: leg)
                    }
                    
                    if placeBetVM.legs.isEmpty {
                        Text("Noch keine Auswahlen getroffen")
                            .foregroundColor(CD.acc)
                            .padding(.top, 280)
                    }
                }.onTapGesture {
                    choosingStake = false
                }
                
                /*
                 Choosing Stake
                 */
                if choosingStake{
                    HStack(spacing: 16) { // Abstand zwischen den
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(0..<stakeOptions.count, id: \.self) { index in
                                    Button{
                                        placeBetVM.setStake(stake: stakeOptions[index])
                                        choosingStake = false
                                    }label:{
                                        Text("\(stakeOptions[index], specifier: "%.2f")")
                                            .foregroundColor(CD.txt1)
                                            .padding(.horizontal, 16)
                                            .padding(.top, 8)
                                            .padding(.bottom, 8)
                                            .background{
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(CD.txt1, lineWidth: 2)
                                                
                                            }
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding() // Abstand innerhalb des HStack
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.bg2)
                            // Hintergrundfarbe für die gesamte HStack
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CD.acc, lineWidth: 1) // Rahmen mit Akzentfarbe
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Leichte Schatten
                    
                }
                
                /*
                 Gesamtqoute und Einsatz
                 */
                HStack(spacing: 16) { // Abstand zwischen den Spalten
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Gesamtquote")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                        
                        Text(placeBetVM.legs.isEmpty ? "---" : "\(placeBetVM.price, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }
                    Spacer()
                    Button{
                        print("CHOOSE STAKE")
                        choosingStake.toggle()
                    }label:{
                        VStack(spacing: 4) {
                            Text("Einsatz")
                                .font(.caption)
                                .foregroundColor(CD.txt2)
                            
                            Text("\(placeBetVM.stake, specifier: "%.2f")")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(CD.txt1)
                        }
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Auszahlung")
                            .font(.caption)
                            .foregroundColor(CD.txt2)
                        
                        Text(placeBetVM.legs.isEmpty ? "---" : "\(placeBetVM.price*placeBetVM.stake, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }
                    Spacer()
                }
                .padding() // Abstand innerhalb des HStack
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CD.bg2)
                        // Hintergrundfarbe für die gesamte HStack
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(CD.acc, lineWidth: 1) // Rahmen mit Akzentfarbe
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Leichte Schatten
                .onTapGesture {
                    choosingStake = false
                }
                /*
                 Wette abgeben Knopf
                 */
                
                Button{
                    print("Place Bet")
                }label: {
                    HStack{
                        Text("Wette abgeben")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(CD.txt1)
                        Image(systemName: "chevron.right")
                            .fontWeight(.bold)
                            .foregroundColor(CD.txt1)
                    }.background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(CD.acc.opacity(0.6))
                            .stroke(CD.acc.opacity(0.8), lineWidth: 4)
                            .frame(width: 300, height: 50)
                    }.padding(.top, 10)
                        .padding(.bottom, 15)
                    
                }.opacity(placeBetVM.isBetValid && !choosingStake ? 1 : 0.3)
                    .disabled(!placeBetVM.isBetValid && !choosingStake)
                
            }
        }
    }
}

#Preview {
    PlaceBetView()
        .environmentObject(PlaceBetViewModel())
}
