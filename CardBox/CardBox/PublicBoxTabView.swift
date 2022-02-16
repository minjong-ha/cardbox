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
	var countCards: Int = 0
	var publicCards: Card
    
    init() {
		//TODO: load Cards from RealmSwift
        print("DEBUG: load PublicBoxTabView")

		let realm = try! Realm()
		let cards = realm.objects(Card.self)
		publicCards = cards.where {
			$0.isPrivate == false
		}
		//TODO: Check it!
		countCards = publicCards.count
		print("DEBUG: countCards is \(countCards)")
    }
    
	//TODO: add button for var body: some View
    var body: some View {
        //TODO: replace it with vertical list cards from RealmSwift
		//TODO: create new View ==> CardView.swift to show the Card (will support modify and delete)
		//TODO: onAppear load Cards List and update countCards
		//if Card exist in Realm --> List Card (https://www.hackingwithswift.com/quick-start/swiftui/composing-views-to-create-a-list-row)
		//else print current info screen
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
    }
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
