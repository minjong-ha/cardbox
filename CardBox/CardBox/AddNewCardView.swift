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

struct AddNewCardView: View {
    
    @Environment(\.dismiss) var dismiss
    let realm = try! Realm()
    
    @StateObject var locationViewModel = LocationViewModel()
    @FocusState private var isFocused: Bool
    @Namespace var contentsID
    
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
    
    @State private var currentDate = Date.now
    @State private var encryptedPassword = "" // key
    @State private var tagList: Array<String> = []
    
    @State var isTitleExist: Bool = false
    @State var isTagExist: Bool = false
    @State var isPasswordExist: Bool = false
    
    var body: some View {
        ScrollViewReader { value in
        ScrollView() {
            VStack (alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Title")
                        .bold()
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
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
                                self.doAddTagAlert()
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
                    HStack (alignment: .center) {
                        Text("Location")
                            .bold()
                        Button(action: {
                            self.locationConfig()
                        }) {
                            Image(systemName: "map")
                        }
                        
                    }
                    TextField("Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                    
                    //.focused($focusedKeyboard, equals: .location)
                }
                
                VStack(alignment: .leading) {
                    Text("Contents")
                        .bold()
                    TextEditor(text: $contents)
                        .cornerRadius(10.0)
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 2.0)
                        .frame(height: UIScreen.main.bounds.size.height / 4)
                        .frame(width: (UIScreen.main.bounds.size.width * 0.9))
                        .onTapGesture {
                            withAnimation(Animation.easeInOut(duration: 1)) { value.scrollTo(contentsID, anchor: .topLeading) }
                        }
                        //.focused($focusedKeyboard, equals: .contents)
                        .focused($isFocused)

                }
                .id(self.contentsID)
                
                VStack (alignment: .leading) {
                    HStack (alignment: .center) {
                        Text("Private?")
                        Button (action: {
                            AlertManager().isPrivateAlert()
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isPrivate)
                            .onTapGesture {
                                withAnimation {
                                    self.isPrivate.toggle()
                                    if (self.isPrivate == false) {
                                        self.isEncrypt = false
                                        self.encryptedPassword.removeAll()
                                    }
                                }
                            }
                        
                        Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                    }
                    if (self.isPrivate) {
                        HStack (alignment: .center) {
                            Text("Encrypted?")
                            Button (action: {
                                AlertManager().isEncryptedAlert()
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            
                            Toggle("", isOn: $isEncrypt)
                                .onTapGesture {
                                    withAnimation {
                                        self.isEncrypt.toggle()
                                        if (self.isEncrypt == false) {
                                            self.encryptedPassword.removeAll()
                                        }
                                    }
                                }
                                .tint(.yellow)
                                .opacity(self.isPrivate ? 1 : 0)
                                .transition(.slide)
                            
                            Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                        }
                    }
                    if (self.isEncrypt) {
                        VStack(alignment: .leading) {
                            Text("Password")
                            SecureField("Enter a Password", text: $encryptedPassword)
                                .textFieldStyle(.roundedBorder)
                                .cornerRadius(10)
                                .opacity(self.isEncrypt ? 1 : 0)
                                .transition(.slide)
                               // .focused($focusedKeyboard, equals: .password)
                                .focused($isFocused)

                        }
                    }
                    HStack (alignment: .center) {
                        Text("Cloud?")
                        Button (action: {
                            AlertManager().isCloudAlert()
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isCloud)
                            .tint(.blue)
                        
                        Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                        
                    }
                    HStack (alignment: .center) {
                        Text("Checked?")
                        Button (action: {
                            AlertManager().isCheckedAlert()
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        
                        Toggle("", isOn: $isChecked)
                            .tint(.orange)
                        
                        Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                        
                    }
                }
            }
        }
        .padding()
        }
        .navigationTitle("Add a new Card")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isFocused = false
                    self.checkAddPossible()
                    let isAddable = self.isFieldEmpty()
                    
                    //if (!self.isTagExist || !self.isTitleExist || !self.isPasswordExist) {
                    print("DEBUG: isTagExist, isTitleExist, isPasswordExist", self.isTagExist, self.isTitleExist, self.isPasswordExist)
                    if (isAddable) {
                        AlertManager().isEmptyFieldAlert()
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
                Spacer()
                Button(action: {
                    self.isFocused = false
                }) {
                    Text("Done")
                }
            }
        }
        .onAppear {
            self.onAppearUpdate()
        }
    }
    
    private func isFieldEmpty() -> Bool {
        var ret: Bool = false
        
        if (!self.isTagExist || !self.isTitleExist || !self.isPasswordExist) { ret = true }
        
        return ret
    }
    
    private func checkAddPossible() {
        if (!self.tag.isEmpty) { self.isTagExist = true }
        if (!self.title.isEmpty) { self.isTitleExist = true }
        
        if (self.isEncrypt) {
            if (!self.encryptedPassword.isEmpty) { self.isPasswordExist = true }
            else { self.isPasswordExist = false}
        }
        else {
            if (self.encryptedPassword.isEmpty) { self.isPasswordExist = true }
            else { self.isPasswordExist = false }
        }
    }
    
    private func onAppearUpdate() {
        //TODO: refactoring-changing RealmManager()
        //TODO: get Lists and sorting tags depending on the isPrivate....!!!
        //let cardInfoList = realm.objects(CardInfo.self) // return objects
        let cardInfoList = RealmObjectManager().getRealmCardInfoList()
        self.uuid = NSUUID().uuidString
        
        
        //if isPrivate, else condition required!
        if (cardInfoList!.count > 0) {
            for cardInfo in cardInfoList! {
                //TODO: refactoring-changing RealmManager()
                let card = realm.object(ofType: Card.self, forPrimaryKey: cardInfo.cardUUID) //return objects
                let cardTag : String = card!.cardTag
                let cardTitle : String = card!.cardTitle
                
                print("DEBUG: ", cardTag, cardTitle)
                //TODO: refactoring ArrayManager required...
                if (!self.tagList.contains(cardTag)) {
                    self.tagList.append(cardTag)
                }
            }
            
            self.tagList.sort {
                $0 < $1
            }
        }
    }
    
    private func realmUpdateCard() {
        self.date = DateManager().getStringfromDate(date: self.currentDate)
        
        let card = RealmObjectManager().initRealmCard(uuid: self.uuid, title: self.title, tag: self.tag, location: self.location, date: self.date, contents: self.contents)
        let cardInfo = RealmObjectManager().initRealmCardInfo(uuid: self.uuid, isPrivate: false, isEncrypt: self.isEncrypt, isCloud: self.isCloud, isChecked: self.isChecked)
        let cardKey = RealmObjectManager().initRealmCardKey(uuid: self.uuid, key: self.encryptedPassword)
        
        RealmObjectManager().realmCardUpdate(card: card)
        RealmObjectManager().realmCardInfoUpdate(cardInfo: cardInfo)
        RealmObjectManager().realmCardKeyUpdate(cardKey: cardKey)
    }
    
    func setLocation() {
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
                    self.location = addr
                }
            })
        }
        else {
            self.location = "Unable to get Location"
        }
    }
    
    //TODO: refactoring make it module in AlertView...
    func doAddTagAlert() {
        let alertController = UIAlertController(title: "Add New Tag", message: "You can add a new tag", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New Tag"
        }
        
        let saveAction = UIAlertAction(title: "Add Tag", style: .default, handler: { alert -> Void in
            let secondTextField = alertController.textFields![0] as UITextField
            self.tag = secondTextField.text!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
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
}

struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView()
    }
}
