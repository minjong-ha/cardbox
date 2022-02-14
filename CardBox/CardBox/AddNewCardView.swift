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
    
	//Card Data
    @State var title: String = ""
    @State var tag: String = ""
    @State var location: String = ""
    @State var date: String = ""
    @State var contents: String = ""
    
    @State var isPrivate: Bool = false //if true, proceed private card creation. not public
	@State var isEncrpy: Bool = false //if true, the card requires individual decrpytion
	@State var isCloud: Bool = false //if true, the card data will be saved in iCloud either
    
    init() {
        print("DEBUG: load AddNewCardView")
    }
    
    var body: some View {
        VStack (alignment: .leading) {
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
                    Text("Date")
                    TextField("Date", text: $date) //TODO: replace it to the datepicker!
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Location")
                TextField("Location", text: $location) //TODO: autofill current location! as String!
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading) {
                Text("Contents")
                TextField("Contents", text: $contents)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button(action: {
                //TODO: Write new Card data into the RealmSwift
                print("DEBUG: Add New Card! Button Action")
                self.title = ""
                self.tag = ""
                self.location = ""
                self.contents = ""
                //TODO: And then go back to the parent view
            }) {
                Text("Add New Card!")
            }
        }
        .navigationTitle("Add a new Card")
        .onAppear {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            print("DEBUG: AddCardView onAppear()")
            date = dateFormatter.string(from: today)
        }
        .onDisappear {
            print("DEBUG: AddCardView onDisappear")
        }
        //Add button that save the json data into RealmSwift! as "Public"
        
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView()
    }
}
