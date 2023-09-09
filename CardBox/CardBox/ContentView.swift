//
//  ContentView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//  ContentView is a kind of main view.

import SwiftUI

struct ContentView: View {
    @State private var selection: Int = 1 // default tab bar is Public Box
    
    var body: some View {
        TabView(selection: $selection) {
            tabView(for: .privateBox)
            tabView(for: .publicBox)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func tabView(for tab: Tab) -> some View {
        let view: AnyView
        let tag: Int
        switch tab {
        case .privateBox:
            view = AnyView(PrivateBoxTabView())
            tag = 0
        case .publicBox:
            view = AnyView(PublicBoxTabView())
            tag = 1
        }
        return view.tabItem {
            Image(systemName: tab.imageName(for: selection == tag))
            Text(tab.title)
        }
        .tag(tag)
    }
    
    private enum Tab {
        case privateBox
        case publicBox
        
        var title: String {
            switch self {
            case .privateBox: return "Private Box"
            case .publicBox: return "Public Box"
            }
        }
        
        func imageName(for isSelected: Bool) -> String {
            switch self {
            case .privateBox:
                return isSelected ? "lock.open" : "lock"
            case .publicBox:
                return "person.3"
            }
        }
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
