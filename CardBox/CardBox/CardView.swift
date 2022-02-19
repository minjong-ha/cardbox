//
//  CardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/19.
//

import SwiftUI
import RealmSwift

struct CardView: View {
    @State var cardCell: CardCell
    
    @State var localTag: String
    @State var localDate: String
    @State var localContents: String
    @State var localLocation: String
    
    //TODO: Change cardCell.inValue to localValue for textfield text
    private func onAppearUpdate() {
        if (self.cardCell.cardTitle == "") {
            self.cardCell.cardTitle = "Empty Title"
        }
        if (self.cardCell.cardTag == "") {
            self.cardCell.cardTag = "Empty Tag"
        }
        if (self.cardCell.cardLocation == "") {
            self.cardCell.cardLocation = "No Location"
        }
        if (self.cardCell.cardDate == "") {
            self.cardCell.cardDate = "No Date"
        }
        if (self.cardCell.cardContents == "") {
            self.cardCell.cardContents = "Empty Contents"
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Tag")
                    TextField(self.cardCell.cardTag, text: $localTag)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }
                VStack(alignment: .leading) {
                    Text("Date")
                    TextField(self.cardCell.cardTag, text: $localDate)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                        .foregroundColor(.clear)
                    
                }
            }
            .frame(width: .infinity)
            Text(self.cardCell.cardLocation)
                    .font(.title)
            Text(self.cardCell.cardContents)
                    .font(.title)
        }
        .onAppear(perform: self.onAppearUpdate)
        .navigationTitle(self.cardCell.cardTitle)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CardView()
    }
}
