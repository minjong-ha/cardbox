//
//  PublicBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI
import FoldingCell
import Combine




//TODO: add SwiftRealm and struct for it

struct PublicBoxTabView: View {
    
    
    init() {
        print("DEBUG: load PublicBoxTabView")
    }
    
    var body: some View {
        
        //TODO: replace it with vertical list cards from RealmSwift
        NavigationView {
            VStack (alignment: .leading) {
                Text("This is the Public Box which contains public cards!")
                Text("Press 'Add' to write a new card!")
            }
            .padding()
            .navigationTitle("Public Box")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: OnDemandView(AddNewCardView())) {
                        Text("Add")
                    }
                }
            }
        }
        .onAppear {
            print("DEBUG: PublicBoxTabView onAppear")
        }
        .onDisappear {
            print("DEBUG: PublicBoxTabView onDisappear")
        }
    }
}




struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
