//
//  ContentView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1 //default tab bar is Public Box
    
    var body: some View {
        TabView(selection: $selection) {
            PrivateBoxTabView()
                .tabItem {
                        Image(systemName: selection == 0 ? "lock.open" : "lock")
                        Text("Private Box")
                }
                .tag(0)
            
            PublicBoxTabView() //TODO: refresh each views only whenever I press the tabItem button! now it reload all the Views...
                .tabItem {
                        Image(systemName: "person.3")
                        Text("Public Box")
                }
                .tag(1)
        }
        .padding()
    }
}

/*
 * Each Views represents the page.
 * TabView adds tabItem connecting the other Views
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
