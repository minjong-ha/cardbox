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
    
    @State var title: String = ""
    @State var tag: String = ""
    @State var location: String = ""
    @State var date: String = ""
    @State var contents: String = ""
    
    @State var isPrivate: Bool = false //if true, proceed private card creation. not public
    
    init() {
        let today = Date()
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        _date = State(initialValue: dateFormatter.string(from: today))
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
                    TextField("Date", text: $date) //TODO: adjust font smaller
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Location")
                TextField("Location", text: $location)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading) {
                Text("Contents")
                TextField("Contents", text: $contents)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .navigationTitle("Add a new Card")
        //Add button that save the json data into RealmSwift! as "Public"
        
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView()
    }
}
