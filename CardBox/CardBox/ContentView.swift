//
//  ContentView.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI

//TODO: add section in ContentView
struct ContentView: View {
    var body: some View {
        TabView {
            PrivateBoxTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Private")
                }
            PublicBoxTabView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Public")
                }
        }
    }
}

/*
 * Each Views represents the page.
 * TabView add TabView button connecting the other Views
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
