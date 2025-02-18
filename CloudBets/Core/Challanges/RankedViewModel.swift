//
//  RankedViewModel.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 13.02.25.
//

import Foundation
import FirebaseFirestore
class RankedViewModel : ObservableObject{
    
    @Published var top50 : [DBUser] = []
}
