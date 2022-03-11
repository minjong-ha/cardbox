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


//TODO: remove white edge(edgesafeArea) https://www.hohyeonmoon.com/blog/swiftui-tutorial-view/

struct PublicBoxTabView: View {
    
    let realm = try! Realm()
    
    @State var isPublicExist: Bool = false
    @State var publicCardCellList: Array<CardCell> = []
	@State var publicInfoList: Array<CardInfoCell> = []
    
    @State var isEditing = false
    @State private var searchText: String = ""
    
    @State var tagList: Array<String> = []
    
    @FocusState private var isFocused: Bool
    
    init() {
        //SwiftUI does not like load in init(). Use onAppear() instead
		//=======================================================
		UITableView.appearance().backgroundColor = .clear  // List background Color
        //UITableView.appearance().separatorStyle = .none // List Cell separator style
		//UITableViewCell.appearance().backgroundColor = .black
		//UITableView.appearance().tableFooterView = UIView()
		//=======================================================
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
            self.publicCardCellList.removeAll()
            
            for publicCardInfo in publicCardInfoList {
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)
                let publicInfoCell = CardInfoCell.init(cardUUID: publicCard!.cardUUID, isPrivate: publicCardInfo.isPrivate, isEncrypt: publicCardInfo.isEncrypt, isCloud: publicCardInfo.isCloud, isChecked: publicCardInfo.isChecked)
                let publicCardCell = CardCell.init(cardUUID: publicCard!.cardUUID, cardTag: publicCard!.cardTag, cardTitle: publicCard!.cardTitle, cardLocation: publicCard!.cardLocation, cardDate: publicCard!.cardDate, cardContents: publicCard!.cardContents, cardInfo: publicInfoCell)
                let cardTag : String = publicCard!.cardTag
                
                self.publicCardCellList.append(publicCardCell)
                if (!self.tagList.contains(cardTag)) {
                    self.tagList.append(cardTag)
                }
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
                let publicCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: publicCardCell.cardUUID)
                print("DEBUG: deleting RealmObject ", publicCard!.cardTitle)
                
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
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack {
                    HStack {
                        TextField("Search ...", text: $searchText)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .focused($isFocused)
                            .onTapGesture {
                                self.isEditing = true
                            }
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)
                                    
                                    if isEditing {
                                        Button(action: {
                                            self.searchText = ""
                                            self.isEditing = false
                                            self.isFocused = false
                                        }) {
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                }
                            )
                            .padding(.horizontal, 10)
                            .opacity(self.isPublicExist ? 1 : 0)
                    }
                    
                    List {
                        ForEach(self.tagList, id: \.self) { section in
                            Section(header: Text(section).bold().font(.title3), content:  {
                                let sectionCardCellList = self.publicCardCellList.filter { card in
                                    return card.cardTag == section
                                }
                                if (sectionCardCellList.count > 0) {
                                    ForEach(sectionCardCellList, id: \.self) { publicCardCell in
                                        if (self.searchText == "") {
                                            NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                                HStack {
                                                    Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                                }
                                            }
                                        }
                                        else {
                                            if (publicCardCell.cardTitle.contains(self.searchText)) {
                                                NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                                    HStack {
                                                        Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onDelete(perform: self.onDeleteCard)
                                }
                            })
                        }
                    }
                    .frame(width: (UIScreen.main.bounds.size.width * 0.95))
                    .opacity(self.isPublicExist ? 1 : 0)
                    .transition(.slide)
                    .shadow(radius: 3.0)
                }
                
                VStack(alignment: .leading) {
                    Text("This is the Public Box which contains public cards!")
                    Text("Press 'Add' to write a new card!")
                }
                .opacity(self.isPublicExist ? 0 : 1)
                .transition(.slide)
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
		//.edgesIgnoringSafeArea(.all)
    }
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
