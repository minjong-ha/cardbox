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

//TODO: pass sectionVisible: Array<Bool> and make it toggle with arrow button. reference PrivateBox icon toggle!
//TODO: pass rows for the cards in the section and make it sort depending on the configuration
struct SectionTitleView: View {
    @State var sectionTitle: String
    @Binding var isVisible: Bool
    
    var body: some View {
        //TODO: leading the sectionTitle
        //TODO: trailing the Menu and Button
        HStack {
            Text(self.sectionTitle)
                .bold()
                .font(.title2)
            
            Spacer()
            
            Menu {
                Button(action: {
                    //set section category setup
                }) {
                    Text("ABC Ascending")
                }
                Button(action: {
                    //set section category setup
                }) {
                    Text("ABC Descending")
                }
                Button(action: {
                    //set section category setup
                }) {
                    Text("Date Ascending")
                }
                Button(action: {
                    //set section category setup
                }) {
                    Text("Date Ascending")
                }
                
            } label : {
                Image(systemName: "arrow.up.arrow.down.square")
                //TextField("Sorting.....", text: $sectionText)
                //.multilineTextAlignment(.leading)
            }
            
            Button (action: {
                //do toggle and for row opacity
                withAnimation {
                    self.isVisible.toggle()
                    print("section isVisible:", self.isVisible)
                }
            }) {
                // Image(systemName: self.selection == 0 ? "lock.open" : "lock")
                Image(systemName: self.isVisible ? "chevron.down" : "chevron.right")
                    
            }
            .transition(.slide)
        }
    }
}
//TODO: remove white edge(edgesafeArea) https://www.hohyeonmoon.com/blog/swiftui-tutorial-view/

struct PublicBoxTabView: View {
    
    @State private var sectionList: Array<SectionCell> = []
    
    private let realm = try! Realm()
    
    @State private var isPublicExist: Bool = false
    @State private var tagList: Array<String> = []
    
    @State private var isEditing = false
    @State private var searchText: String = ""
    @State private var searchTag: String = ""
    
    @FocusState private var isFocused: Bool
    
    
    init() {
        //SwiftUI does not like load in init(). Use onAppear() instead
		//=======================================================
        //UITableView.appearance().backgroundColor = .clear  // List background Color
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
        print("isPublicExist: ", self.isPublicExist)
    }
    
    private func onDeleteCard(at indexSet: IndexSet, in section: SectionCell) {
        try! realm.write {
            indexSet.forEach ({ index in
                let publicCardCell = section.cardCellList[index]
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardCell.cardUUID)
                let publicCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: publicCardCell.cardUUID)
                print("DEBUG: deleting RealmObject ", publicCard!.cardTitle)

                let sectionIndex = self.sectionList.firstIndex(where: { $0.cardTag == publicCard!.cardTag  } )
                
                if(publicCard != nil) {
                    realm.delete(publicCard!)
                    realm.delete(publicCardInfo!)
                    self.sectionList[sectionIndex!].cardCellList.remove(at: index)
                }
                else {
                    print("DEBUG: There is no matched RealmObject!")
                }
            })
        }
        self.onAppearUpdate()
    }
    
    var body: some View {
        NavigationView {
            if (isPublicExist) {
                //TODO: remove VStack...?
                VStack {
                    List {
                        ForEach (self.$sectionList, id: \.self) { $section in
                            Section(header: SectionTitleView(sectionTitle: section.cardTag, isVisible: $section.isVisible), content:  {
                                ForEach(section.cardCellList, id: \.self) { publicCardCell in
                                    if (self.searchText == "" && section.isVisible) {
                                        NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                            HStack {
                                                Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                            }
                                        }
                                        .transition(.opacity)
                                    }
                                    else {
                                        if (publicCardCell.cardTitle.contains(self.searchText) && section.isVisible) {
                                            NavigationLink(destination: OnDemandView(CardView(cardUUID: publicCardCell.cardUUID, localTitle: publicCardCell.cardTitle, localTag: "", localDate: "", localContents: "", localLocation: "", localPrivate: publicCardCell.cardInfo.isPrivate, localEncrypt: publicCardCell.cardInfo.isEncrypt, localCloud: publicCardCell.cardInfo.isCloud, localChecked: publicCardCell.cardInfo.isChecked, isEditState: false))) {
                                                HStack {
                                                    Label("\(publicCardCell.cardTitle)", systemImage: "envelope.fill")
                                                }
                                            }
                                            .transition(.opacity)
                                        }
                                    }
                                }
                                .onDelete {
                                    self.onDeleteCard(at: $0, in: section)
                                }
                            })
                        }
                    }
                    .searchable(text: $searchText) //Reference: https://sarunw.com/posts/searchable-in-swiftui/
                    .transition(.slide)
                    .shadow(radius: 3.0)
                    .listStyle(PlainListStyle())
                }
                .navigationTitle(Text("Public Box"))
                .onAppear(perform: self.onAppearUpdate)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: OnDemandView(AddNewCardView())) {
                            Text("Add")
                        }
                    }
                }
            }
            
            else {
                VStack(alignment: .leading) {
                    Text("This is the Public Box which contains public cards!")
                    Text("Press 'Add' to write a new card!")
                }
                .onAppear(perform: self.onAppearUpdate)
                .navigationTitle(Text("Public Box"))
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
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
