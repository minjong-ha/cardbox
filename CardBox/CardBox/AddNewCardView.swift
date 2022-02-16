//
//  AddNewCardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/13.
//

import Foundation
import SwiftUI
import Combine

struct AddNewCardView: View {
    @Environment(\.dismiss) var dismiss
    
	//Card Data
	//TODO: make a Card class for RealmSwift
    @State var uuid: String =  ""
    @State var title: String = ""
    @State var tag: String = ""
    @State var location: String = ""
    @State var date: String = ""
    @State var contents: String = ""
    
    @State var isPrivate: Bool = false //if true, proceed private card creation. not public
	@State var isEncrypt: Bool = false //if true, the card requires individual decrpytion
	@State var isCloud: Bool = false //if true, the card data will be saved in iCloud either
    
    init() {
        print("DEBUG: load AddNewCardView")
    }
    
    var body: some View {
        VStack (alignment: .center) {
             VStack(alignment: .leading) {
                 Text("Title")
                 TextField("Title", text: $title)
                     .textFieldStyle(.roundedBorder)
             }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Tag")
                    TextField("Tag", text: $tag)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading) {
					//TODO: replace it to the datepicker!
                    Text("Date")
                    TextField("Date", text: $date) 
                        .textFieldStyle(.roundedBorder)
				}
            }
            
           VStack(alignment: .leading) {
			   //TODO: autofill current location! as String!
			    Text("Location")
                TextField("Location", text: $location) 
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading) {
				//TODO: use TextEditor(lib) for multiline textfield! for vertically expandable textfield!
                Text("Contents")
                TextField("Contents", text: $contents)
                    .textFieldStyle(.roundedBorder)
            }
            
            //TODO: this is for empty space for now. find right way! (https://stackoverflow.com/questions/60324478/how-to-add-blank-space-at-the-bottom-of-a-form-in-swiftui)
			//TODO: study about the padding (https://www.hackingwithswift.com/quick-start/swiftui/how-to-control-spacing-around-individual-views-using-padding)
            Text("(empty space)")
                .hidden()
            
            Button(action: {
                //TODO: Write new Card data into the RealmSwift
				let realm = try! Realm()

				let card = Card()
				let card_authority = Authority()

                let uuid = NSUUID().uuidString
                self.uuid = uuid

				card.cardUUID = self.uuid
				card.cardTitle = self.title
				card.cardTag = self.tag
				card.cardLocation = self.location
				card.cardDate = self.date
				card.cardContents = self.contents

				card_authority.cardUUID = self.uuid
				card_authority.isPrivate = self.isPrivate
				card_authority.isEncrypt = self.isEncrypt
				card_authority.isCloud = self.isCloud

				//TODO: what if the data is empty(nil)? + make it module in Card and Authority classes
				try! realm.write {
					realm.add(card, update: true)
					realm.add(card_authority, update: true)
				}
                
                print("DEBUG: Add New Card! Button Action")
                print("DEBUG:", self.uuid)
                
                //TODO: refresh parent view when AddNewCardView dismiss -> use onAppear in parent view
                self.dismiss()
            }) {
                Text("Add New Card!")
                    .font(.system(size: 20))
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Add a new Card")
        .onAppear {
            let today = Date()
            let dateFormatter = DateFormatter()
            
			//TODO: configurable date format? add new ConfigView + data + interaction
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" 
            
            print("DEBUG: AddCardView onAppear()")
            self.date = dateFormatter.string(from: today)
        }
        .onDisappear {
            print("DEBUG: AddCardView onDisappear")
        }
        
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        //AddNewCardView(false: )
        ContentView()
    }
}
