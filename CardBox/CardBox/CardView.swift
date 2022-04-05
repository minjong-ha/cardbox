//
//  CardView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/19.
//

import CoreLocation
import SwiftUI
import RealmSwift

struct CardView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationViewModel = LocationViewModel()
    @Namespace var contentsID
    
    @State var cardUUID: String
    @State var localTitle: String
    @State var localTag: String
    @State var localDate: String
    @State var localContents: String
    @State var localLocation: String
    
    @State var localPrivate: Bool
    @State var localEncrypt: Bool
    @State var localCloud: Bool
    @State var localChecked: Bool
    
    @State var isEditState: Bool
    @State var currentDate = Date.now
    
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView() {
                VStack(alignment: .center) {
                    if (self.isEditState) {
                        VStack (alignment: .leading) {
                            Text("Title")
                                .font(.title2)
                                .bold()
                                .opacity(self.isEditState ? 1 : 0)
                                .transition(.slide)
                            TextField(self.localTitle, text: $localTitle)
                            //.shadow(radius: 3.0)
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
                            //.shadow(radius: 3.0)
                        }
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.title2)
                                .bold()
                            HStack(alignment: .center) {
                                DatePicker("", selection: $currentDate, displayedComponents: .date)
                                    .disabled(self.isEditState == false)
                                DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                                    .disabled(self.isEditState == false)
                            }
                        }
                    }
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Location")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                self.locationConfig()
                            }) {
                                Image(systemName: "map")
                            }
                          }
                        TextField(self.localLocation, text: $localLocation)
                            .textFieldStyle(.roundedBorder)
                            .disabled(self.isEditState == false)
                        //.shadow(radius: 3.0)
                    }
                    VStack (alignment: .leading) {
                        Text("Contents")
                            .font(.title2)
                            .bold()
                        TextEditor(text: $localContents)
                            .cornerRadius(10.0)
                            .shadow(radius: 3.0)
                            .frame(height: UIScreen.main.bounds.size.height / 4)
                            .frame(width: (UIScreen.main.bounds.size.width * 0.9))
                            .disabled(self.isEditState == false)
                    }
                    
                    //HStact for three toggle switch
                    VStack (alignment: .leading) {
                        Toggle("Private?", isOn: $localPrivate)
                            .opacity(self.isEditState ? 1: 0)
                            .transition(.slide)
                        Toggle("Encrypted?", isOn: $localEncrypt)
                            .opacity(self.isEditState ? 1: 0)
                            .transition(.slide)
                            .tint(.yellow)
                        Toggle("Cloud?", isOn: $localCloud)
                            .opacity(self.isEditState ? 1: 0)
                            .transition(.slide)
                            .tint(.blue)
                        Toggle("Checked?", isOn: $localChecked)
                            .opacity(self.isEditState ? 1: 0)
                            .transition(.slide)
                            .tint(.orange)
                    }
                }
            }
            .padding()
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
                                let cardInfo = CardInfo()
                                
                                card.cardUUID = self.cardUUID
                                card.cardTitle = self.localTitle
                                card.cardTag = self.localTag
                                card.cardLocation = self.localLocation
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                self.localDate = dateFormatter.string(from: self.currentDate)
                                card.cardDate = self.localDate
                                
                                card.cardContents = self.localContents
                                
                                cardInfo.cardUUID = self.cardUUID
                                cardInfo.isPrivate = self.localPrivate
                                cardInfo.isEncrypt = self.localEncrypt
                                cardInfo.isCloud = self.localCloud
                                cardInfo.isChecked = self.localChecked
                                
                                try! realm.write {
                                    realm.add(card, update: .modified)
                                    realm.add(cardInfo, update: .modified)
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
        }
    }
    
     private func onAppearUpdate() {
        let realm = try! Realm()
        
        let card = realm.object(ofType: Card.self, forPrimaryKey: self.cardUUID)
        self.localTitle = card!.cardTitle
        self.localTag = card!.cardTag
        self.localLocation = card!.cardLocation
        
        self.localDate = card!.cardDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.currentDate = dateFormatter.date(from: self.localDate)!
        
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
    
    private func locationConfig() {
        let authorizationStatus = CLLocationManager().authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            self.locationViewModel.requestPermission()
            self.setLocation()
        case .restricted:
            self.locationViewModel.requestPermission()
            self.setLocation()
        case .denied:
            self.locationViewModel.requestPermission()
            self.setLocation()
        case .authorizedAlways:
            self.setLocation()
        case .authorizedWhenInUse:
            self.setLocation()
        case .authorized:
            self.setLocation()
        @unknown default:
            break
        }
    }
    
    private func setLocation() {
        //TODO: refactoring LocationManager()!
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        if (latitude != nil && longitude != nil) {
            let findLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks {
                    let addr = (address.last?.name)! + ", " + (address.last?.locality)!// + ", " + (address.last?.administrativeArea)!
                    self.localLocation = addr
                }
            })
        }
        else {
            self.localLocation = "Unable to get Location"
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CardView()
    }
}
