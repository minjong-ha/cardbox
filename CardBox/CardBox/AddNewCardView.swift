//
//  AddNewCardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/13.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import CoreLocationUI

//TODO: is this necessary? test it
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}

struct AddNewCardView: View {
    @Environment(\.dismiss) var dismiss
	@StateObject var locationManager = LocationManager()
    
	//Card Data
    @State var uuid: String =  ""
    @State var title: String = ""
    @State var tag: String = ""
    @State var location: String = ""
    @State var date: String = ""
    @State var contents: String = ""
    
    @State var isPrivate: Bool = false //if true, proceed private card creation. not public
	@State var isEncrypt: Bool = false //if true, the card requires individual decrpytion
	@State var isCloud: Bool = false //if true, the card data will be saved in iCloud either

	@State var key: String = "" //work with self.isPrivate!
    
    init() {
        print("DEBUG: load AddNewCardView")

    }
    
	//TODO: check onAppear can use in body
    var body: some View {
        VStack (alignment: .center) {
             VStack(alignment: .leading) {
                 Text("Title")
                 TextField("Title", text: $title)
                     .textFieldStyle(.roundedBorder)
             }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
					//TODO: dropdown for tag, exist tag + new tag(appear additional add tag field) (https://medium.com/geekculture/custom-drop-down-text-field-in-swiftui-a748d2cebbeb) (https://stackoverflow.com/questions/59821797/is-there-a-way-to-populate-a-textfield-in-a-drop-down-manner-in-swiftui)
					//TODO: add textfield for new view (alert) (https://stackoverflow.com/questions/56726663/how-to-add-a-textfield-to-alert-in-swiftui)
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
				//TODO: character limit (https://stackoverflow.com/questions/56476007/swiftui-textfield-max-length)
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

			//TODO: get address from latitude and longitude (https://devsc.tistory.com/82) 
			if let location = locationManager.location {
				self.location = "\(location.latitude) \(location.longitude)"
			}
            
			//TODO: configurable date format? add new ConfigView + data + interaction
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" 
            
            print("DEBUG: AddCardView onAppear()")
            self.date = dateFormatter.string(from: today)
        }
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        //AddNewCardView(false: )
        ContentView()
    }
}
