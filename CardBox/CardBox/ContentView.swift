//
//  ContentView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//  ContentView is a kind of main view.

import SwiftUI

//TODO: organize *.swift files into the directories considering their purpose

struct ContentView: View {
    @State private var selection : Int = 1 //default tab bar is Public Box
    
    var body: some View {
        TabView(selection: $selection) {
			//TODO: onGesture Touch/Facd ID? if failed, do not lead it PrivateBoxTabView()!
            PrivateBoxTabView()
                .tabItem {
                    Image(systemName: self.selection == 0 ? "lock.open" : "lock")
                        Text("Private Box")
                }
                .tag(0)

            //TODO: refresh each views only whenever I press the tabItem button! now it reload all the Views...
            PublicBoxTabView() 
                .tabItem {
                        Image(systemName: "person.3")
                        Text("Public Box")
                }
                .tag(1)
        }
        .ignoresSafeArea(.keyboard)
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
