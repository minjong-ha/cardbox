//
//  PublicBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI
import FoldingCell
import Combine
import RealmSwift

struct PublicBoxTabView: View {

	var countPublicCardList: Int
    var publicCardList: Results<Card>
    
    init() {
        print("DEBUG: load PublicBoxTabView")
        
        let realm = try! Realm()

		let cardList = realm.objects(Card.self)
        let configList = realm.objects(CardConfig.self)

		let publicConfigList = configs.where {
			$0.isPrivate == false
		}

		//TODO: check this plot, grammar
		for publicConfig in publicConfigs {
			let publicUUID = publicConfig.cardUUID
			let publicCard = realm.object(ofTypes: Person.self, forPrimaryKey: publicUUID)
			self.publicCardList.append(publicCard)
		}
		print("publicCardList: ", self.publicCardList.count)
		for publicCard in publicCardList {
			print("Public Card: ", publicCard.title)
		}
    }
    
	//TODO: add button for var body: some View
    var body: some View {
        //TODO: replace it with vertical list cards from RealmSwift
		//TODO: create new View ==> CardView.swift to show the Card (will support modify and delete)
		//TODO: onAppear load Cards List and update countCards
		//if Card exist in Realm --> List Card (https://www.hackingwithswift.com/quick-start/swiftui/composing-views-to-create-a-list-row) (https://peterfriese.dev/posts/swiftui-listview-part4/)
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
