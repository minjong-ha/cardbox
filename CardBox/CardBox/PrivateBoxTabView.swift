//
//  PrivateBox.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//

import SwiftUI
import LocalAuthentication
import RealmSwift
import Combine


struct PrivateBoxTabView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private let realm = try! Realm()
    
    @State private var tagList: Array<String> = []
    @State private var sectionList: Array<SectionCell> = []
    
    @State private var isPrivateExist: Bool = false
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var searchText: String = ""
    @State private var searchTag: String = ""
    
	//TODO: add encrypt config - only contents, full (title, tag, contents)
	//TODO: encrpytion candidates (https://developer.apple.com/documentation/applearchive/encrypting_and_decrypting_a_string) (https://developer.apple.com/documentation/cryptokit/)
	//TODO: faceID/touchID (https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui) (https://www.andyibanez.com/posts/integrating-face-id-touch-id-swiftui/)
    //TODO: refactoring ScrollView in PublicBoxTabView
    
    //TODO: export inUnlocked to the ContentView for locked, unlocked image
    @State private var isUnlocked: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        let reason = "Test to private security"
        
        if (self.isUnlocked == false) {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { success, authenticationError in
                    if success {
                        print ("do something")
                        self.isUnlocked = true
                    }
                    else {
                        print("fail. don't show the data")
                        self.isUnlocked = false
                    }
                })
            }
            else {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { success, authenticationError in
                    if success {
                        print ("success in non Biometrics")
                        self.isUnlocked = true
                    }
                    else {
                        print("fail. in non Biometrics")
                        self.isUnlocked = false
                    }
                })
            }
        }
    }
    
    
    init() {
        print("DEBUG: load PrivateBoxTabView")
    }
    
    var body: some View {
        NavigationView {
            if (isUnlocked) {
                if (isPrivateExist) {
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
                    .navigationTitle(Text("Private Box"))
                    .navigationBarTitleDisplayMode(.large)
                    //.onAppear(perform: self.onAppearUpdate)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            AddButtonView()
                        }
                    }
                }
                
                // there is no card in the private box
                else { EmptyPrivateBoxView() }
            }
            // isUnlocked false. authentication fail
            else { LockedPrivateBoxView() }
        }
        .onAppear(perform: self.onAppearUpdate)
    }
    
    func onAppearUpdate() {
        //faceID / touchID
        self.isUnlocked = false
        print("onAppearUpdate in PrivateBoxTabView")
        self.authenticate()
        
        let cardInfoList = realm.objects(CardInfo.self)
        let privateCardInfoList = cardInfoList.where {
            $0.isPrivate == true
            //$0.isPrivate == false
        }
        
        self.sectionList.removeAll()
        
        if (privateCardInfoList.count > 0) {
            self.isPrivateExist = true
            
            for privateCardInfo in privateCardInfoList {
                let privateCard = realm.object(ofType: Card.self, forPrimaryKey: privateCardInfo.cardUUID)
                let privateInfoCell = CardInfoCell.init(cardUUID: privateCard!.cardUUID, isPrivate: privateCardInfo.isPrivate, isEncrypt: privateCardInfo.isEncrypt, isCloud: privateCardInfo.isCloud, isChecked: privateCardInfo.isChecked)
                let privateCardCell = CardCell.init(cardUUID: privateCard!.cardUUID, cardTag: privateCard!.cardTag, cardTitle: privateCard!.cardTitle, cardLocation: privateCard!.cardLocation, cardDate: privateCard!.cardDate, cardContents: privateCard!.cardContents, cardInfo: privateInfoCell)
                let cardTag : String = privateCard!.cardTag
                
                var isExist = false
                for section in self.sectionList {
                    if (section.cardTag == cardTag) {
                        isExist = true
                    }
                }
                if (!isExist) {
                    var newSection = SectionCell.init()
                    newSection.cardTag = cardTag
                    newSection.cardCellList.append(privateCardCell)
                    self.sectionList.append(newSection)
                }
                else {
                    let index = self.sectionList.firstIndex(where: { $0.cardTag == cardTag })!
                    self.sectionList[index].cardCellList.append(privateCardCell)
                }
            }
            
            self.sectionList.sort {
                $0.cardTag < $1.cardTag
            }
        }
        else {
            self.isPrivateExist = false
        }

    }
    
    private func onDeleteCard(at indexSet: IndexSet, in section: SectionCell) {
        indexSet.forEach ({ index in
            let privateCardCell = section.cardCellList[index]
            let privateCard = realm.object(ofType: Card.self, forPrimaryKey: privateCardCell.cardUUID)
            let privateCardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: privateCardCell.cardUUID)
            let privateCardKey = realm.object(ofType: CardKey.self, forPrimaryKey: privateCardCell.cardUUID)
            
            if(privateCard != nil) {RealmObjectManager().realmCardDelete(card: privateCard!)}
            if(privateCardInfo != nil) {RealmObjectManager().realmCardInfoDelete(cardInfo: privateCardInfo!)}
            if(privateCardKey != nil) {RealmObjectManager().realmCardKeyDelete(cardKey: privateCardKey!)}
        })
        self.onAppearUpdate()
    }
}

struct PrivateBox_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //PrivateBoxTabView<Any>()
    }
}
