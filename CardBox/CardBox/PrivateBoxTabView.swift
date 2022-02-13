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
                Text("This is the Private Box which contains secret cards!")
                Text("Press 'Add' to write a new secret card!")
                
            }
            .padding()
            .navigationTitle("Private Box")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddNewCardView()) {
                        Text("Add")
                    }
                }
            }
        }
    }
}

struct PrivateBox_Previews: PreviewProvider {
    static var previews: some View {
        PrivateBoxTabView()
    }
}
