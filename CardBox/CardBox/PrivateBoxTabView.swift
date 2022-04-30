//
//  PrivateBox.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/12.
//

import SwiftUI
import LocalAuthentication

struct PrivateBoxTabView: View {
    
	//TODO: add encrypt config - only contents, full (title, tag, contents)
	//TODO: encrpytion candidates (https://developer.apple.com/documentation/applearchive/encrypting_and_decrypting_a_string) (https://developer.apple.com/documentation/cryptokit/)
	//TODO: faceID/touchID (https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui) (https://www.andyibanez.com/posts/integrating-face-id-touch-id-swiftui/)
    
    init() {
        print("DEBUG: load PrivateBoxTabView")
        
        //faceID / touchID
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                Text("This is the Private Box which contains secret cards!")
                Text("Press 'Add' to write a new secret card!")
                
            }
            //.padding()
            .navigationTitle("Private Box")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddButtonView()
                }
            }
        }
    }
    
    func privateAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {success, authenticatorError in
                if success {
                    //authenticated successfully!
                }
                else {
                    //authentication fail!
                }
            }
        }
        else {
            //no biometrics! password plz!
        }
    }
}

struct PrivateBox_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //PrivateBoxTabView<Any>()
    }
}
