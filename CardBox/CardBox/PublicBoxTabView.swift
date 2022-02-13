//
//  PublicBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI
import FoldingCell
import Combine

struct PublicBoxTabView: View {
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                Text("Public Box")
                    .font(.system(size: 30)) //TODO: dynamic font size depending on the screen size!
                Text("This is the Public Box which contains public cards!")
            }
            .navigationTitle("Public Box")
            .padding()
        }
    }
}



struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
