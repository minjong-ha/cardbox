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
				//TODO: use TextEditor(lib) for multiline textfield!
                Text("Contents")
                TextField("Contents", text: $contents)
                    .textFieldStyle(.roundedBorder)
            }
            
            //TODO: this is for empty space for now. find right way!
            Text("(empty space)")
                .hidden()
            
            Button(action: {
                //TODO: Write new Card data into the RealmSwift
                print("DEBUG: Add New Card! Button Action")
                self.title = ""
                self.tag = ""
                self.location = ""
                self.contents = ""
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
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            print("DEBUG: AddCardView onAppear()")
            date = dateFormatter.string(from: today)
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
