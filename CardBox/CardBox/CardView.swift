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
    
    @State private var encryptedPassword = "" // key
    //=====
    @State private var tagList: Array<String> = []
    //=====
    
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
                                .textFieldStyle(.roundedBorder)
                                .disabled(self.isEditState == false)
                                .opacity(self.isEditState ? 1 : 0)
                                .transition(.slide)
                        }
                    }
                    
                    HStack(alignment: .top) {
                        /*
                        VStack(alignment: .leading) {
                            Text("Tag")
                                .font(.title2)
                                .bold()
                            TextField(self.localTag, text: $localTag)
                                .textFieldStyle(.roundedBorder)
                                .disabled(self.isEditState == false)
                         }
                         */
                        
                        //==========================================================
                        VStack(alignment: .leading) {
                            Text("Tag")
                                .bold()
                            Menu {
                                ForEach(self.tagList, id: \.self) { cardTag in
                                    Button(action: {
                                        self.localTag = cardTag
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
                                TextField("Tag", text: $localTag)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        //==========================================================
                        
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
                        TextField("no location info", text: $localLocation)
                            .textFieldStyle(.roundedBorder)
                            .disabled(self.isEditState == false)
                    }
                    VStack (alignment: .leading) {
                        Text("Contents")
                            .font(.title2)
                            .bold()
                        
                        //TODO: textedit disabled but scrolling
                        TextEditor(text: $localContents)
                            .cornerRadius(10.0)
                            .shadow(radius: 3.0)
                            .frame(height: UIScreen.main.bounds.size.height / 4)
                            .frame(width: (UIScreen.main.bounds.size.width * 0.9))
                            .disabled(self.isEditState == false)
                            .onTapGesture {
                                withAnimation(Animation.easeInOut(duration: 1)) { value.scrollTo(contentsID, anchor: .topLeading) }
                            }
                            .transition(.slide)
                    }
                    .id(self.contentsID)
                    
                    
                    if (isEditState) {
                    VStack (alignment: .leading) {
                        HStack (alignment: .center) {
                            Text("Private?")
                            Button (action: {
                                AlertManager().isPrivateAlert()
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            
                            Toggle("", isOn: $localPrivate)
                                .onTapGesture {
                                    withAnimation {
                                        self.localPrivate.toggle()
                                        if (self.localPrivate == false) {
                                            self.localEncrypt = false
                                            self.encryptedPassword.removeAll()
                                        }
                                    }
                                }
                            
                            Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                        }
                        if (self.localPrivate) {
                            HStack (alignment: .center) {
                                Text("Encrypted?")
                                Button (action: {
                                    AlertManager().isEncryptedAlert()
                                }) {
                                    Image(systemName: "questionmark.circle")
                                }
                                
                                Toggle("", isOn: $localEncrypt)
                                    .onTapGesture {
                                        withAnimation {
                                            self.localEncrypt.toggle()
                                            if (self.localEncrypt == false) {
                                                self.encryptedPassword.removeAll()
                                            }
                                        }
                                    }
                                    .tint(.yellow)
                                    .opacity(self.localPrivate ? 1 : 0)
                                    .transition(.slide)
                                
                                Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                            }
                        }
                        if (self.localEncrypt) {
                            VStack(alignment: .leading) {
                                Text("Password")
                                SecureField("Enter a Password", text: $encryptedPassword)
                                    .textFieldStyle(.roundedBorder)
                                    .cornerRadius(10)
                                    .opacity(self.localEncrypt ? 1 : 0)
                                    .transition(.slide)
                                // .focused($focusedKeyboard, equals: .password)
                                    //.focused($localFocused)
                                
                            }
                        }
                        HStack (alignment: .center) {
                            Text("Cloud?")
                            Button (action: {
                                AlertManager().isCloudAlert()
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            
                            Toggle("", isOn: $localCloud)
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
                            
                            Toggle("", isOn: $localChecked)
                                .tint(.orange)
                            
                            Spacer(minLength: UIScreen.main.bounds.size.width * 0.05)
                            
                        }
                    }
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
                                self.realmUpdateCard()
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
    
    private func realmUpdateCard() {
        self.isEditState.toggle()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.localDate = dateFormatter.string(from: self.currentDate)
        
        let card = RealmObjectManager().initRealmCard(uuid: self.cardUUID, title: self.localTitle, tag: self.localTag, location: self.localLocation, date: self.localDate, contents: self.localContents)
        let cardInfo = RealmObjectManager().initRealmCardInfo(uuid: self.cardUUID, isPrivate: self.localPrivate, isEncrypt: self.localEncrypt, isCloud: self.localCloud, isChecked: self.localChecked)
        let cardKey = RealmObjectManager().initRealmCardKey(uuid: self.cardUUID, key: self.encryptedPassword)
        
        RealmObjectManager().realmCardUpdate(card: card)
        RealmObjectManager().realmCardInfoUpdate(cardInfo: cardInfo)
        RealmObjectManager().realmCardKeyUpdate(cardKey: cardKey)
    }
    
    private func onAppearUpdate() {
        let realm = try! Realm()
        let card = realm.object(ofType: Card.self, forPrimaryKey: self.cardUUID)
        
        //============
        let cardInfoList = RealmObjectManager().getRealmCardInfoList()
        self.tagList.removeAll()
        //============
        
        self.localTitle = card!.cardTitle
        self.localTag = card!.cardTag
        self.localLocation = card!.cardLocation
        
        self.localDate = card!.cardDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.currentDate = dateFormatter.date(from: self.localDate)!
        
        self.localContents = card!.cardContents
        
        //=============
        if (cardInfoList == nil) { /*do nothing */ }
        else {
            //if isPrivate, else condition required!
            if (cardInfoList!.count > 0) {
                for cardInfo in cardInfoList! {
                    let card = RealmObjectManager().getRealmCard(uuid: cardInfo.cardUUID) as! Card
                    let cardTag : String = card.cardTag
                    let cardTitle : String = card.cardTitle
                    
                    print("DEBUG: ", cardTag, cardTitle)
                    //TODO: refactoring ArrayManager required...
                    if (!self.tagList.contains(cardTag) && (cardInfo.isPrivate == self.localPrivate)) {
                        self.tagList.append(cardTag)
                    }
                }
                
                self.tagList.sort {
                    $0 < $1
                }
            }
        }
        //=============
        
        
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
    
    func doAddTagAlert() {
        let alertController = UIAlertController(title: "Add New Tag", message: "You can add a new tag", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New Tag"
        }
        
        let saveAction = UIAlertAction(title: "Add Tag", style: .default, handler: { alert -> Void in
            let secondTextField = alertController.textFields![0] as UITextField
            self.localTag = secondTextField.text!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    

}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CardView()
    }
}
