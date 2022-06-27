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
    
    @Environment(\.colorScheme) var colorScheme
    
    private let realm = try! Realm()
    
    @State private var tagList: Array<String> = []
    @State private var sectionList: Array<SectionCell> = []
    
    @State private var isPublicExist: Bool = false
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var searchText: String = ""
    @State private var searchTag: String = ""
    
    /*
     init() {
     //SwiftUI does not like load in init(). Use onAppear() instead
     //=======================================================
     //UITabBar.appearance().barTintColor = .red
     //UITableView.appearance().backgroundColor = .clear  // List background Color
     //UITableView.appearance().separatorStyle = .none // List Cell separator style
     //UITableViewCell.appearance().backgroundColor = .black
     //UITableView.appearance().tableFooterView = UIView()
     //=======================================================
     }
     */
    
    var body: some View {
        NavigationView {
            if (isPublicExist) {
                VStack {
                    List {
                        ForEach (self.$sectionList, id: \.self) { $section in
                            //Section filtering
                            if (section.cardTag.contains(self.searchText)) {
                                Section(header: SectionTitleView(sectionTitle: section.cardTag, isVisible: $section.isVisible, cardList: $section.cardCellList), content:  {
                                    ForEach(section.cardCellList, id: \.self) { publicCardCell in
                                        NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                            HStack {
                                                Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                            }
                                        }
                                    }
                                    .onDelete {
                                        self.onDeleteCard(at: $0, in: section)
                                    }
                                })
                            }
                            
                            //Card filtering
                            else {
                                Section(header: SectionTitleView(sectionTitle: section.cardTag, isVisible: $section.isVisible, cardList: $section.cardCellList), content:  {
                                    ForEach(section.cardCellList, id: \.self) { publicCardCell in
                                        if (self.searchText == "" && section.isVisible) {
                                            NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                                HStack {
                                                    Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                                }
                                            }
                                        }
                                        else {
                                            if (publicCardCell.cardTitle.contains(self.searchText) && section.isVisible) {
                                                NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                                    HStack {
                                                        Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onDelete {
                                        self.onDeleteCard(at: $0, in: section)
                                    }
                                })
                            }
                            
                        }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) //Reference: https://sarunw.com/posts/searchable-in-swiftui/
                    .shadow(radius: 3.0)
                    .listStyle(PlainListStyle())
                }
                .padding([.top], 0)
                .padding([.horizontal])
                .navigationTitle(Text("Public Box"))
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        AddButtonView()
                    }
                }
            }
            
            else {
                VStack(alignment: .leading) {
                    Text("This is the Public Box which contains public cards!")
                    Text("Press 'Add' to write a new card!")
                }
                .padding()
                .padding([.horizontal])
                .navigationTitle(Text("Public Box"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        AddButtonView()
                    }
                }
            }
        }
        .onAppear(perform: self.onAppearUpdate)
    } //body closure
    
    private func onAppearUpdate() {
        print("onAppearUpdate in PublicBoxTabView")
        let cardInfoList = realm.objects(CardInfo.self)
        let publicCardInfoList = cardInfoList.where {
            $0.isPrivate == false
        }
        
        self.sectionList.removeAll()
        
        if (publicCardInfoList.count > 0) {
            self.isPublicExist = true
            
            for publicCardInfo in publicCardInfoList {
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)
                let publicInfoCell = CardInfoCell.init(cardUUID: publicCard!.cardUUID, isPrivate: publicCardInfo.isPrivate, isEncrypt: publicCardInfo.isEncrypt, isCloud: publicCardInfo.isCloud, isChecked: publicCardInfo.isChecked)
                let publicCardCell = CardCell.init(cardUUID: publicCard!.cardUUID, cardTag: publicCard!.cardTag, cardTitle: publicCard!.cardTitle, cardLocation: publicCard!.cardLocation, cardDate: publicCard!.cardDate, cardContents: publicCard!.cardContents, cardInfo: publicInfoCell)
                let cardTag : String = publicCard!.cardTag
                
                var isExist = false
                for section in self.sectionList {
                    if (section.cardTag == cardTag) {
                        isExist = true
                    }
                }
                if (!isExist) {
                    var newSection = SectionCell.init()
                    newSection.cardTag = cardTag
                    newSection.cardCellList.append(publicCardCell)
                    self.sectionList.append(newSection)
                }
                else {
                    let index = self.sectionList.firstIndex(where: { $0.cardTag == cardTag })!
                    self.sectionList[index].cardCellList.append(publicCardCell)
                }
            }
            
            self.sectionList.sort {
                $0.cardTag < $1.cardTag
            }
        }
        else {
            self.isPublicExist = false
        }
    }
    
    private func onDeleteCard(at indexSet: IndexSet, in section: SectionCell) {
        indexSet.forEach ({ index in
            let publicCardCell = section.cardCellList[index]
            let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardCell.cardUUID)
            let publicCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: publicCardCell.cardUUID)
            let publicCardKey = realm.object(ofType: CardKey.self, forPrimaryKey: publicCardCell.cardUUID)
            
            if(publicCard != nil) {RealmObjectManager().realmCardDelete(card: publicCard!)}
            if(publicCardInfo != nil) {RealmObjectManager().realmCardInfoDelete(cardInfo: publicCardInfo!)}
            if(publicCardKey != nil) {RealmObjectManager().realmCardKeyDelete(cardKey: publicCardKey!)}
        })
        self.onAppearUpdate()
    }
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
