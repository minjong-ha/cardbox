//
//  EmptyBoxView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/07/04.
//

import SwiftUI

struct EmptyBoxView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EmptyPublicBoxView: View {
    var body: some View {
        //Empty PublicBox
        VStack(alignment: .leading) {
            Text("This is the Public Box which contains public cards!")
            Text("Press 'Add' to write a new card!")
        }
        .padding()
        .padding([.horizontal])
        .navigationTitle(Text("Public Box"))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AddButtonView()
            }
        }
    }
}

struct EmptyPrivateBoxView: View {
    var body: some View {
        //Empty PrivateBox
        VStack(alignment: .leading) {
            Text("This is the Private Box which contains secret cards!")
            Text("Press 'Add' to write a new secret card!")
        }
        .padding()
        .padding([.horizontal])
        .navigationTitle(Text("Private Box"))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AddButtonView()
            }
        }
    }
}

struct LockedPrivateBoxView: View {
    var body: some View {
        //Locked PrivateBox
        VStack(alignment: .leading) {
            Text("Authentication Fail")
            Text("Pass the Authentication first to see the cards")
        }
        .padding()
        .padding([.horizontal])
        .navigationTitle(Text("Private Box"))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AddButtonView()
            }
        }
    }
}

