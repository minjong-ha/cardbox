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

struct PublicCardCell: Hashable {
    var cardUUID: String // primary key
    
    var cardTag: String
    var cardTitle: String
}

struct PublicBoxTabView: View {
    
    let realm = try! Realm()
    
    @State var publicCardList: Results<Card>
    @State var isPublicExist: Bool = false
    @State var publicCardCellList: Array<PublicCardCell> = []
    
    init() {
        //print("DEBUG: INIT()")
        
        let cardList = realm.objects(Card.self)
        self.publicCardList = cardList.where {
            $0.isPrivate == false
        }
        
        if (self.publicCardList.count > 0) {
            self.isPublicExist = true
            
            self.publicCardCellList.removeAll()
            
            for publicCard in self.publicCardList {
                let publicCardCell = PublicCardCell.init(cardUUID: publicCard.cardUUID, cardTag: publicCard.cardTag, cardTitle: publicCard.cardTitle)
                //print("DEBUG: ", publicCardCell.cardUUID, publicCardCell.cardTag, publicCardCell.cardTitle)
                self.publicCardCellList.append(publicCardCell)
            }
        }
    }
    
    private func onAppearUpdate() {
        //print("DEBUG: onAppearUpdate()")
        let cardList = realm.objects(Card.self)
        self.publicCardList = cardList.where {
            $0.isPrivate == false
        }
        
        if (self.publicCardList.count > 0) {
            self.isPublicExist = true
            
            self.publicCardCellList.removeAll()
            
            for publicCard in self.publicCardList {
                let publicCardCell = PublicCardCell.init(cardUUID: publicCard.cardUUID, cardTag: publicCard.cardTag, cardTitle: publicCard.cardTitle)
                print("DEBUG: ", publicCard.cardTitle, publicCardCell.cardTitle, publicCard.cardTag, publicCardCell.cardTag)
                self.publicCardCellList.append(publicCardCell)
            }
        }
        else {
            self.isPublicExist = false
        }
    }
    
    private func onDeleteCard(at indexSet: IndexSet) {
        try! realm.write {
            indexSet.forEach({ index in
                let publicCardCell = self.publicCardCellList[index]
                print("DEBUG: try to delete ", index, "cell_", publicCardCell.cardUUID, publicCardCell.cardTag, publicCardCell.cardTitle)
                
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardCell.cardUUID)
                print("DEBUG: deleting RealmObject ", publicCard?.cardTitle)
                
                if(publicCard != nil) {
                    realm.delete(publicCard!)
                }
                else {
                    print("DEBUG: There is no matched RealmObject")
                }
            })
        }
        self.onAppearUpdate()
    }
    
    var body: some View {
        if (self.isPublicExist) {
            NavigationView {
                List {
                    ForEach(self.publicCardCellList, id: \.self) { publicCardCell in
                        NavigationLink(destination: OnDemandView(CardView())) {
                            HStack {
                                Text(publicCardCell.cardTag)
                                Text(publicCardCell.cardTitle)
                            }
                        }
                    }
                    .onDelete(perform: self.onDeleteCard)
                    .onAppear(perform: self.onAppearUpdate)
                    .background(Color.clear)
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
