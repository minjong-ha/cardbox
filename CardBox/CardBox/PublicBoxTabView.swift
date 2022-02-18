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
    
    let realm = try! Realm()
    
    @State var publicCardInfoList: Results<CardInfo>
    @State var isExist: Bool = false
    
    init() {
        let cardInfoList = realm.objects(CardInfo.self)
        let cardList = realm.objects(Card.self)
        
        self.publicCardInfoList = cardInfoList.where {
			$0.isPrivate == false
		}
        
        for card in cardList {
            print("DEBUG) card: ", card.cardTitle, card.cardUUID)
        }
        
        for cardInfo in cardInfoList {
            let card = realm.object(ofType: Card.self, forPrimaryKey: cardInfo.cardUUID)
            
            print("DEBUG) cardInfo: ", cardInfo.cardUUID, card?.cardTitle ?? "UNKNOWN")
        }
        
        if (self.publicCardInfoList.count > 0) {
            self.isExist = true
        }
    }
    
    private func onAppearUpdate() {
        print("DEBUG: onAppearUpdate()!!@!")
        let cardInfoList = realm.objects(CardInfo.self)
        
        self.publicCardInfoList = cardInfoList.where {
            $0.isPrivate == false
        }
        
        if (self.publicCardInfoList.count > 0) {
            self.isExist = true
        }
    }
    
    private func onDeleteCard(at indexSet: IndexSet) {
        indexSet.forEach({ index in
            print("DEBUG: SWIPE TO DELETE!", indexSet, index)
        })
        try! realm.write {
            indexSet.forEach {
                let publicInfo = self.publicCardInfoList[$0]
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicInfo.cardUUID)
            }
        }
        //self.onAppearUpdate()
    }
    
    var body: some View {
        if (self.isExist) {
            NavigationView {
                List {
                    ForEach(self.publicCardInfoList, id: \.self) { publicCardInfo in
                        let title = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)?.cardTitle
                        Text(title!)
                    }
                    .onDelete(perform: self.onDeleteCard)
                    .onAppear(perform: self.onAppearUpdate)
                }
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
        else {
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
                .onAppear(perform: self.onAppearUpdate)
            }
        }
    }
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
