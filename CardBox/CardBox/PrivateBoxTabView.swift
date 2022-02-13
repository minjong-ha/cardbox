//
//  PrivateBox.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//

import SwiftUI

struct PrivateBoxTabView: View {
    var body: some View {
        //What is ZStack?
        NavigationView {
            VStack (alignment: .leading) {
                Text("Private Box")
                    .font(.system(size: 30))
            }
            .padding()
            .navigationTitle("Private Box")
        }
    }
}

struct PrivateBox_Previews: PreviewProvider {
    static var previews: some View {
        PrivateBoxTabView()
    }
}
