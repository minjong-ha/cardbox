//
//  PublicBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI
import FoldingCell
import Combine

// I hope it will solve the instant view loading problem
public struct OnDemandView<Content: View>: View {
	private let build(): () -> Content

	public init(_ build: @autoclosure @escaping () -> Content) {
		self.build = build
	}
	
	public var body: Content {
		build()
	}
}


//TODO: add SwiftRealm and struct for it

struct PublicBoxTabView: View {
    
    @State var isNewActive: Bool = false
    
    init() {
        print("DEBUG: load PublicBoxTabView")
    }
    
    var body: some View {
        
        //TODO: replace it with vertical list cards from RealmSwift
        NavigationView {
            VStack (alignment: .leading) {
                Text("Public Box")
                    .font(.system(size: 30)) //TODO: dynamic font size depending on the screen size!
                Text("This is the Public Box which contains public cards!")
                Text("Press 'Add' to write a new card!")
            }
            .padding()
            .navigationTitle("Public Box")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: OnDemandView(AddNewCardView())) { //TODO: refresh navigationlink only it pressed! use NavigationLink with inActive!
                        Text("Add")
                    }
                }
            }
        }
        .onAppear {
            print("DEBUG: PublicBoxTabView onAppear")
        }
    }
}




struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
