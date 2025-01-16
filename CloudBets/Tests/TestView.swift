//
//  TestView.swift
//  CloudBets
//
//  Created by Tom Tiedtke on 29.01.25.
//

import SwiftUI

struct TestView: View {
    var body: some View {

        VStack{
            Button{
                print("magenta")
            } label: {
                ZStack{
                    CD.acc
                        .frame(width: 400, height: 400)
                    Button{
                        print("BLUE")
                    }label: {
                        Color.blue
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
}

#Preview {
    TestView()
}
