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
    
    @State var currentDate = Date.now
    @State var tagList: Array<String> = []
    let realm = try! Realm()
    
    @State var encryptedPassword = "" // key
    
    @State var isTitleExist: Bool = false
    @State var isTagExist: Bool = false
    @State var isPasswordExist: Bool = false
    
    init() {
        print("DEBUG: load AddNewCardView")
        print("DEBUG: ", Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    private func onAppearUpdate() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        print("DEBUG: AddCardView onAppear()")
        self.date = dateFormatter.string(from: self.currentDate)
        //self.date = dateFormatter.string(from: today)
        
        let cardInfoList = realm.objects(CardInfo.self)
        
        if (cardInfoList.count > 0) {
            for cardInfo in cardInfoList {
                let card = realm.object(ofType: Card.self, forPrimaryKey: cardInfo.cardUUID)
                let cardTag : String = card!.cardTag
                let cardTitle : String = card!.cardTitle
                
                print("DEBUG: ", cardTag, cardTitle)
                if (!self.tagList.contains(cardTag)) {
                    self.tagList.append(cardTag)
                }
            }
        }
        print(self.tagList.count)
    }
    
    private func realmUpdateCard() {
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
                        .bold()
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Tag")
                            .bold()
                        Menu {
                            ForEach(self.tagList, id: \.self) { cardTag in
                                Button(action: {
                                    self.tag = cardTag
                                }) {
                                    Text(cardTag)
                                }
                            }
                            Button(action: {
                                let alertController = UIAlertController(title: "Add New Tag", message: "You can add a new tag", preferredStyle: .alert)
                                
                                alertController.addTextField { (textField : UITextField!) -> Void in
                                    textField.placeholder = "New Tag"
                                }
                                
                                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                                    let secondTextField = alertController.textFields![0] as UITextField
                                    self.tag = secondTextField.text!
                                })
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                                
                                alertController.addAction(saveAction)
                                alertController.addAction(cancelAction)
                                
                                UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                            }) {
                                Text("+ Add New Tag")
                            }
                        } label: {
                            TextField("Tag", text: $tag)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Date")
                            .bold()
                        HStack(alignment: .center) {
                            DatePicker("", selection: $currentDate, displayedComponents: .date)
                            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    //TODO: autofill current location! as String!
                    HStack (alignment: .center) {
                        Text("Location")
                            .bold()
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
                    //TODO: Dynamic height textEditor (https://stackoverflow.com/questions/62620613/dynamic-row-hight-containing-texteditor-inside-a-list-in-swiftui)
                    //(https://stackoverflow.com/questions/65459579/texteditor-added-swiftui)
                    //default text: (https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui) // ZStack
                    Text("Contents")
                        .bold()
                    TextEditor(text: $contents)
                        .cornerRadius(10.0)
                        .shadow(radius: 3.0)
                        .frame(height: UIScreen.main.bounds.size.height / 4)
                        .frame(width: (UIScreen.main.bounds.size.width * 0.9))
                }
                
                VStack (alignment: .leading) {
                    HStack (alignment: .center) {
                        Text("Private?")
                        Button (action: {
                            let alertController = UIAlertController(title: "Private?", message: "If the 'Private' is active,\nthe card will be located in PrivateBox, not PublicBox", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                            alertController.addAction(cancelAction)
                            
                            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isPrivate)
                            .onTapGesture {
                                withAnimation {
                                    self.isPrivate.toggle()
                                }
                            }
                    }
                    if (self.isPrivate) {
                        HStack (alignment: .center) {
                            Text("Encrypted?")
                            Button (action: {
                                let alertController = UIAlertController(title: "Encrypted?", message: "If the 'Encrypt' is active,\nthe card will be encrypted with the 'Password'", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                                alertController.addAction(cancelAction)
                                
                                UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            
                            Toggle("", isOn: $isEncrypt)
                                .onTapGesture {
                                    withAnimation {
                                        self.isEncrypt.toggle()
                                    }
                                }
                                .tint(.yellow)
                                .opacity(self.isPrivate ? 1 : 0)
                                .transition(.slide)
                            
                        }
                    }
                    if (self.isEncrypt) {
                        VStack(alignment: .leading) {
                            Text("Password")
                            SecureField("Enter a Password", text: $encryptedPassword)
                                .textFieldStyle(.roundedBorder)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .opacity(self.isEncrypt ? 1 : 0)
                                .transition(.scale)
                        }
                    }
                    HStack (alignment: .center) {
                        Text("Cloud?")
                        Button (action: {
                            let alertController = UIAlertController(title: "Cloud?", message: "If the 'Cloud' is active,\nthe card will be backup automatically in the iCloud", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                            alertController.addAction(cancelAction)
                            
                            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isCloud)
                            .tint(.blue)
                        
                    }
                    HStack (alignment: .center) {
                        Text("Checked?")
                        Button (action: {
                            let alertController = UIAlertController(title: "Checked?", message: "If the 'Checked is active,\nthe card will be lined in the Box", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                            alertController.addAction(cancelAction)
                            
                            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isChecked)
                            .tint(.orange)
                        
                    }
                }
            }
          }
        .navigationTitle("Add a new Card")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    if (!self.tag.isEmpty) { self.isTagExist = true }
                    if (!self.title.isEmpty) { self.isTitleExist = true }
                    if (self.isEncrypt) {
                        if (!self.encryptedPassword.isEmpty) { self.isPasswordExist = true }
                    }
                    else { self.isPasswordExist = true }
                    
                    if (!self.isTagExist || !self.isTitleExist || !self.isPasswordExist) {
                        let alertController = UIAlertController(title: "Warning!\nThere are empty fields!", message: "Title, Tag, and Password(optional)\nshould not be empty!", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
                        alertController.addAction(cancelAction)
                        
                        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        self.realmUpdateCard()
                        self.dismiss()
                    }
                }) {
                    Text("Add")
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: {
                    UIApplication.shared.keyWindow?.endEditing(true)
                }) {
                   Text("Done")
                }
                Spacer()
            }
        }
        .onAppear {
            self.onAppearUpdate()
        }
    }
  }

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        //AddNewCardView(false: )
        ContentView()
    }
}
