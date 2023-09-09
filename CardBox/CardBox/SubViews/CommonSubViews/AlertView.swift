//
//  AlertView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/29.
//

import SwiftUI

class AlertManager {
    
    let PRIVATE_ALERT_TITLE: String = "Private?"
    let PRIVATE_ALERT_MESSAGE: String = "If the 'Private' is active,\nthe card will be located in the PrivateBox"
    
    let ENCRYPTED_ALERT_TITLE: String = "Encrypted?"
    let ENCRYPTED_ALERT_MESSAGE: String = "If the 'Encrypted' is active, \nthe contents of the card will be encrypted"
    
    let CLOUD_ALERT_TITLE: String = "Cloud?"
    let CLOUD_ALERT_MESSAGE: String = "If the 'Cloud' is active, \nthe card will be backup into the user's iCloud"
    
    let CHECKED_ALERT_TITLE: String = "Checked?"
    let CHECKED_ALERT_MESSAGE: String = "If the 'Checked is active,\nthe card will be lined in the Box"
    
    let EMPTY_ALERT_TITLE: String = "Warning!\nThere are empty fields!"
    let EMPTY_ALERT_MESSAGE: String = "Title, Tag, and Password(optional)\nshould not be empty!"
    
    func isPrivateAlert() {
        let alertController = UIAlertController(title: PRIVATE_ALERT_TITLE, message: PRIVATE_ALERT_MESSAGE, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isEncryptedAlert() {
        let alertController = UIAlertController(title: ENCRYPTED_ALERT_TITLE, message: ENCRYPTED_ALERT_MESSAGE, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isCloudAlert() {
        let alertController = UIAlertController(title: CLOUD_ALERT_TITLE, message: CLOUD_ALERT_MESSAGE, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isCheckedAlert() {
        let alertController = UIAlertController(title: CHECKED_ALERT_TITLE, message: CHECKED_ALERT_MESSAGE, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isEmptyFieldAlert() {
        let alertController = UIAlertController(title: EMPTY_ALERT_TITLE, message: EMPTY_ALERT_MESSAGE, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        alertController.addAction(cancelAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
  
    func doAddTagAlert(tagBinding: Binding<String>) {
        let alertController = UIAlertController(title: "Add New Tag", message: "You can add a new tag", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New Tag"
        }
        
        let saveAction = UIAlertAction(title: "Add Tag", style: .default, handler: { alert -> Void in
            if let secondTextField = alertController.textFields?.first, let text = secondTextField.text {
                tagBinding.wrappedValue = text
            }
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
