//
//  CardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/19.
//

import SwiftUI
import RealmSwift

struct CardView: View {
    @State var cardUUID: String
    
    @State var localTitle: String
    @State var localTag: String
    @State var localDate: String
    @State var localContents: String
    @State var localLocation: String
    
	@State var isEditState: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    private func onAppearUpdate() {
        let realm = try! Realm()
        
        let card = realm.object(ofType: Card.self, forPrimaryKey: self.cardUUID)
        self.localTitle = card!.cardTitle
        self.localTag = card!.cardTag
        self.localLocation = card!.cardLocation
        self.localDate = card!.cardDate
        self.localContents = card!.cardContents
        
        if (self.localTitle == "") {
            self.localTitle = "Empty Title"
        }
        if (self.localTag == "") {
            self.localTag = "No Tag"
        }
        if (self.localLocation == "") {
            self.localLocation = "No Location Info"
        }
        if (self.localDate == "") {
            self.localDate = "No Date Info"
        }
        if (self.localContents == "") {
            self.localContents = "No Contents Data"
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if (self.isEditState) {
                VStack (alignment: .leading) {
                    Text("Title")
                        .font(.title2)
                        .bold()
                        .opacity(self.isEditState ? 1 : 0)
                        .transition(.slide)
                    TextField(self.localTitle, text: $localTitle)
                        .textFieldStyle(.roundedBorder)
                        .disabled(self.isEditState == false)
                        .opacity(self.isEditState ? 1 : 0)
                        .transition(.slide)
                }
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Tag")
                        .font(.title2)
                        .bold()
                    TextField(self.localTag, text: $localTag)
                        .textFieldStyle(.roundedBorder)
                        .disabled(self.isEditState == false)
                }
                VStack(alignment: .leading) {
                    Text("Date")
                        .font(.title2)
                        .bold()
                    TextField(self.localDate, text: $localDate)
                        .textFieldStyle(.roundedBorder)
                        .disabled(self.isEditState == false)
                }
            }
            VStack (alignment: .leading) {
                Text("Location")
                    .font(.title2)
                    .bold()
                TextField(self.localLocation, text: $localLocation)
                    .textFieldStyle(.roundedBorder)
                    .disabled(self.isEditState == false)
            }
            VStack (alignment: .leading) {
                Text("Contents")
                    .font(.title2)
                    .bold()
                TextEditor(text: $localContents)
                    .textFieldStyle(.roundedBorder)
                    .disabled(self.isEditState == false)
            }
            
            //HStact for three toggle switch
            
        }
        .onAppear(perform: self.onAppearUpdate)
        .navigationTitle(self.localTitle)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if (self.isEditState) {
                    Button (action: {
                        withAnimation {
                            self.isEditState.toggle()
                            
                            let realm = try! Realm()
                            let card = Card()
                            
                            card.cardUUID = self.cardUUID
                            card.cardTitle = self.localTitle
                            card.cardTag = self.localTag
                            card.cardLocation = self.localLocation
                            card.cardDate = self.localDate
                            card.cardContents = self.localContents
                            
                            try! realm.write {
                                realm.add(card, update: .modified)
                            }
                        }
                    }) {
                        Text("Confirm")
                    }
                }
                else {
                    Button (action: {
                        withAnimation {
                            self.isEditState.toggle()
                        }
                    }) {
                        Text("Edit")
                    }
                }
            }
        }
        //the toggle button (SwiftUI Toggle) will be appear (using "transition") from bottom (it will be added to the AddNewCardView either)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CardView()
    }
}