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
        
        if (publicCardInfoList.count > 0) {
            self.isPublicExist = true
            self.sectionList.removeAll()
            
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
                    var isExist = false
                    let index = self.sectionList.firstIndex(where: { $0.cardTag == cardTag })!
                    for card in self.sectionList[index].cardCellList {
                        if (card.cardUUID == publicCardCell.cardUUID) {
                            isExist = true
                        }
                    }
                    if (!isExist) {
                        self.sectionList[index].cardCellList.append(publicCardCell)
                    }
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
        try! realm.write {
            indexSet.forEach ({ index in
                let publicCardCell = section.cardCellList[index]
                let publicCard = realm.object(ofType: Card.self, forPrimaryKey: publicCardCell.cardUUID)
                let publicCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: publicCardCell.cardUUID)
                print("DEBUG: deleting RealmObject ", publicCard!.cardTitle)
                
                if(publicCard != nil) {
                    realm.delete(publicCard!)
                    realm.delete(publicCardInfo!)
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
            ZStack() {
                VStack {
                    List {
                        ForEach (self.sectionList, id: \.self) { section in
                            Section(header: Text(section.cardTag).bold().font(.title3), content:  {
                                ForEach(section.cardCellList, id: \.self) { publicCardCell in
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
                                .onDelete {
                                    self.onDeleteCard(at: $0, in: section)
                                }
                            })
                        }
                    }
                    .searchable(text: $searchText)
                    .frame(width: (UIScreen.main.bounds.size.width * 0.95))
                    .opacity(self.isPublicExist ? 1 : 0)
                    .transition(.slide)
                    .shadow(radius: 3.0)
                    .listStyle(SidebarListStyle())
                }
                
                VStack(alignment: .leading) {
                    Text("This is the Public Box which contains public cards!")
                    Text("Press 'Add' to write a new card!")
                }
                .opacity(self.isPublicExist ? 0 : 1)
                .transition(.slide)
                .padding()
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
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
