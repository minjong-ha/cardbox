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
import RealmSwift

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

struct AddNewCardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var locationViewModel = LocationViewModel()
    
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
    @State var isChecked: Bool = false //if ture, the card contents will be exposed with delete line
    
    @State var key: String = "" //work with self.isPrivate!
    
    @State var currentDate = Date.now
    
    init() {
        print("DEBUG: load AddNewCardView")
        print("DEBUG: ", Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    func setLocation() {
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        if (latitude != nil && longitude != nil) {
            let findLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks {
                    if let name: String = address.last?.name { self.location = name }
                }
            })
        }
        else {
            self.location = "Unable to get Location"
        }
    }
    
	//TODO: check onAppear can use in body
    var body: some View {
        ScrollView() {
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
						//TODO: https://developer.apple.com/forums/thread/126990
                        //TODO: https://stackoverflow.com/questions/56489107/using-swiftui-how-can-i-add-datepicker-only-while-textfield-is-in-editing-mode
                        Text("Date")
                        HStack(alignment: .center) {
                            DatePicker("", selection: $currentDate, displayedComponents: .date)
                            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        }
                        //TextField("Date", text: $date)
                         //   .textFieldStyle(.roundedBorder)
                    }
                }
                
                VStack(alignment: .leading) {
                    //TODO: autofill current location! as String!
                    HStack (alignment: .center) {
                        Text("Location")
                        //TODO: more accurate interact
                        Button(action: {
                            var authorizationStatus = CLLocationManager().authorizationStatus
                            
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
                            }
                        }) {
                            Image(systemName: "map")
                        }
                        
                    }
                    TextField("Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading) {
					//TODO: move textfield up when the keyboard pop (https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui)
					//TODO: add next button for keyboard (https://stackoverflow.com/questions/58673159/how-to-move-to-next-textfield-in-swiftui)
                    //TODO: character limit + TextEditor Background color problem (https://stackoverflow.com/questions/56476007/swiftui-textfield-max-length)
                    //(https://stackoverflow.com/questions/65459579/texteditor-added-swiftui)
                    //default text: (https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui) // ZStack
                    Text("Contents")
                    TextEditor(text: $contents)
                        .cornerRadius(10.0)
                        .shadow(radius: 3.0)
                        .frame(height: UIScreen.main.bounds.size.height / 4)
                        .frame(width: (UIScreen.main.bounds.size.width * 0.9))
                }
                
                //TODO: add help icon and description
                VStack (alignment: .leading) {
                    Toggle("Private?", isOn: $isPrivate)
                    Toggle("Encrypted?", isOn: $isEncrypt)
                        .tint(.yellow)
                    Toggle("Cloud?", isOn: $isCloud)
                        .tint(.blue)
                    Toggle("Checked?", isOn: $isChecked)
                        .tint(.orange)
                }
            }
        }
        .navigationTitle("Add a new Card")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                Button(action: {
                    let realm = try! Realm()
                    
                    let card = Card()
                    let cardInfo = CardInfo()
                    
                    let uuid = NSUUID().uuidString
                    self.uuid = uuid
                    
                    card.cardUUID = self.uuid
                    card.cardTitle = self.title
                    card.cardTag = self.tag
                    card.cardLocation = self.location
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    self.date = dateFormatter.string(from: self.currentDate)
                    card.cardDate = self.date
                    
                    card.cardContents = self.contents
                    
                    cardInfo.cardUUID = self.uuid
                    //cardInfo.isPrivate = self.isPrivate
                    cardInfo.isPrivate = false
                    cardInfo.isEncrypt = self.isEncrypt
                    cardInfo.isCloud = self.isCloud
                    cardInfo.isChecked = self.isChecked
                    
                    //TODO: what if the data is empty(nil)? + make it module in Card and Authority classes
                    try! realm.write {
                        realm.add(card, update: .modified)
                        realm.add(cardInfo, update: .modified)
                    }
                    
                    print("DEBUG: Add New Card! Button Action")
                    print("DEBUG:", self.uuid)
                    print("DEBUG:", self.title)
                    print("DEBUG:", self.tag)
                    print("DEBUG:", self.location)
                    print("DEBUG:", self.date)
                    print("DEBUG:", self.contents)
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.dismiss()
                }) {
                    Text("Add")
                }
            }
        }
        .onAppear {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            print("DEBUG: AddCardView onAppear()")
            self.date = dateFormatter.string(from: self.currentDate)
            //self.date = dateFormatter.string(from: today)
        }
        /*
        .onDisappear(perform:  {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            print("DEBUG: AddNewCard View onDisappear")
        })
        */
    }
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        //AddNewCardView(false: )
        ContentView()
    }
}
