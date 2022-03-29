//
//  AlertView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/29.
//

import SwiftUI

class AlertManager {
    func isPrivateAlert() {
        let alertController = UIAlertController(title: "Private?", message: "If the 'Checked is active,\nthe card will be lined in the Box", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isEncryptedAlert() {
        let alertController = UIAlertController(title: "Encrypted?", message: "If the 'Checked is active,\nthe card will be lined in the Box", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isCloudAlert() {
        let alertController = UIAlertController(title: "Cloud?", message: "If the 'Checked is active,\nthe card will be lined in the Box", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isCheckedAlert() {
        let alertController = UIAlertController(title: "Checked?", message: "If the 'Checked is active,\nthe card will be lined in the Box", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func isEmptyFieldAlert() {
        let alertController = UIAlertController(title: "Warning!\nThere are empty fields!", message: "Title, Tag, and Password(optional)\nshould not be empty!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        alertController.addAction(cancelAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
