//
//  CardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/19.
//

import SwiftUI
import RealmSwift

//TODO: change architecture local --> RealmObject load
struct CardView: View {
    @State var cardUUID: String
    
    @State var localTitle: String
    @State var localTag: String
    @State var localDate: String
    @State var localContents: String
    @State var localLocation: String

	@State var isEditState: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    //TODO: Change cardCell.inValue to localValue for textfield text
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
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Tag")
                        .font(.title2)
                        .bold()
                    TextField(self.localTag, text: $localTag)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }
                VStack(alignment: .leading) {
                    Text("Date")
                        .font(.title2)
                        .bold()
                    TextField(self.localDate, text: $localDate)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }
            }
            VStack (alignment: .leading) {
                Text("Location")
                    .font(.title2)
                    .bold()
                TextField(self.localLocation, text: $localLocation)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
            VStack (alignment: .leading) {
                Text("Contents")
                    .font(.title2)
                    .bold()
                TextEditor(text: $localContents)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
            
        }
        .onAppear(perform: self.onAppearUpdate)
        .navigationTitle(self.localTitle) // am i have to make it editable? title textField will be appear when the edit button enabled?
		//Add NavigationTab Button on right top : Edit
		//When I press the edit button, edit button becomes Confirm
		//The TextField and TextEditor becomes enable
		//the toggle button (SwiftUI Toggle) will be appear (using "transition") from bottom (it will be added to the AddNewCardView either)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CardView()
    }
}
