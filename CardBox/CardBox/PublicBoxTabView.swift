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
    
    @State var isPublicExist: Bool = false
    @State var publicCardCellList: Array<CardCell> = []
	@State var publicInfoList: Array<CardInfoCell> = []
    
    init() {
        //print("DEBUG: INIT()")
        
        let cardInfoList = realm.objects(CardInfo.self)
        let publicCardInfoList = cardInfoList.where {
            $0.isPrivate == false
        }
        
        //if (self.publicCardList.count > 0) {
        if (publicCardInfoList.count > 0) {
            self.isPublicExist = true
            self.publicCardCellList.removeAll()
            
            
            for publicCardInfo in publicCardInfoList {
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)
                let publicCardCell = CardCell.init(cardUUID: publicCard!.cardUUID, cardTag: publicCard!.cardTag, cardTitle: publicCard!.cardTitle)
				let publicInfoCell = CardInfoCell.init(cardUUID: publicCardInfo.cardUUID, isPrivate: publicCardInfo.isPrivate, isEncrypt: publicCardInfo.isEncrypt, isCloud: publicCardInfo.isCloud, isChecked: publicCardInfo.isChecked)
				publicCardCell.cardInfo = publicInfoCell
                self.publicCardCellList.append(publicCardCell)
            }
        }
        else {
            self.isPublicExist = false
        }
    }
    
    private func onAppearUpdate() {
        
        let cardInfoList = realm.objects(CardInfo.self)
        let publicCardInfoList = cardInfoList.where {
            $0.isPrivate == false
        }
        
        //if (self.publicCardList.count > 0) {
        if (publicCardInfoList.count > 0) {
            self.isPublicExist = true
            self.publicCardCellList.removeAll()
            
            for publicCardInfo in publicCardInfoList {
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)
                let publicCardCell = CardCell.init(cardUUID: publicCard!.cardUUID, cardTag: publicCard!.cardTag, cardTitle: publicCard!.cardTitle)
                self.publicCardCellList.append(publicCardCell)
            }
        }
        else {
            self.isPublicExist = false
        }
        //print("DEBUG: onAppearUpdate()")
        //=======================================================
        //UITableView.appearance().backgroundColor = .clear  // List background Color
        //UITableViewCell.appearance().backgroundColor = .black
        //UITableView.appearance().tableFooterView = UIView()
        //=======================================================
    }
    
    private func onDeleteCard(at indexSet: IndexSet) {
        try! realm.write {
            indexSet.forEach({ index in
                let publicCardCell = self.publicCardCellList[index]
                print("DEBUG: try to delete ", index, "cell_", publicCardCell.cardUUID, publicCardCell.cardTag, publicCardCell.cardTitle)
                
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardCell.cardUUID)
                let publicCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: publicCardCell.cardUUID)
                print("DEBUG: deleting RealmObject ", publicCard?.cardTitle)
                
                if(publicCard != nil) {
                    realm.delete(publicCard!)
                    realm.delete(publicCardInfo!)
                }
                else {
                    print("DEBUG: There is no matched RealmObject")
                }
            })
        }
        self.onAppearUpdate()
    }
    
    //TODO: bind with hidden https://stackoverflow.com/questions/56490250/dynamically-hiding-view-in-swiftui
	//TODO: no seperate NavigationView... We need integrated View. 
    var body: some View {
        if (self.isPublicExist) {
            NavigationView {
                List {
                    ForEach(self.publicCardCellList, id: \.self) { publicCardCell in
                        //NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", isEditState: false))) {
                        NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: false, localEncrypt: false, localCloud: false, localChecked: false, isEditState: false))) {
                            HStack {
                                Text(publicCardCell.cardTag)
                                Text(publicCardCell.cardTitle)
                            }
                        }
                    }
                    .onDelete(perform: self.onDeleteCard)
                    //.listRowBackground(Color.gray)
                }
                .onAppear(perform: self.onAppearUpdate)
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
