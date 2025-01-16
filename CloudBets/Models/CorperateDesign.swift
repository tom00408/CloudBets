//
//  CorperateDesign.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 24.01.25.
//

import Foundation
import SwiftUI
/*
 
 Zweck    Farbe    Hex-Code
 Haupt-Hintergrund    Schwarz    #000000
 Sekundärer Hintergrund    Dunkelgrau    #1C1C1E
 Primärtext    Weiß    #FFFFFF
 Sekundärtext    Hellgrau    #D1D1D6
 Hauptakzent    Lila    #8E44AD
 Akzent-Hover    Hell-Lila    #DCC6E0
 Fehler    Rot    #E74C3C
 Erfolg    Grün    #2ECC71
 Warnung    Gelb    #F1C40F
 Deaktiviert    Grau    #636366
 */

class CD{
    
    static let bg1 = Color(hex: "#000000")
    static let bg2 = Color(hex: "#1C1C1E")
    static let bg3 = Color(hex: "#2C2C2E")  
    
    static let txt1 = Color(hex:"#FFFFFF")
    static let txt2 = Color(hex: "#D1D1D6")
    
    static let acc = Color(hex: "#8E44AD")
    static let accHover = Color(hex: "#DCC6E0")
    
    static let error = Color(hex: "#E74C3C")
    static let success = Color(hex: "#2ECC71")
    static let warning = Color(hex: "#F1C40F")
    
    static let deact = Color(hex: "#636366")
    
}
