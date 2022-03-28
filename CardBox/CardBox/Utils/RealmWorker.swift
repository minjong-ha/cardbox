//
//  RealmWorker.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/28.
//

import SwiftUI
import RealmSwift

class RealmUpdater {
    let realm = try! Realm()
    
    func realmCardUpdate(card: Card) {
        try! realm.write {
            realm.add(card, update: .modified)
        }
    }
    
    func realmCardInfoUpdate(cardInfo: CardInfo) {
        try! realm.write {
            realm.add(cardInfo, update: .modified)
        }
    }

    func realmCardKeyUpdate(cardKey: CardKey) {
        try! realm.write {
            realm.add(cardKey, update: .modified)
        }
    }
}

class RealmObjectManager {
    func getRealmCard(uuid: String, title: String, tag: String, location:String, date: String, contents: String) -> Card {
        let card = Card()
        
        card.cardUUID = uuid
        card.cardTitle = title
        card.cardTag = tag
        card.cardLocation = location
        card.cardDate = date
        card.cardContents = contents
        
        return card
    }
    func getRealmCardInfo(uuid: String, isPrivate: Bool, isEncrypt: Bool, isCloud: Bool, isChecked: Bool) -> CardInfo {
        let cardInfo = CardInfo()
        
        cardInfo.cardUUID = uuid
        cardInfo.isPrivate = isPrivate
        cardInfo.isEncrypt = isEncrypt
        cardInfo.isCloud = isCloud
        cardInfo.isChecked = isChecked
        
        return cardInfo
    }
    func getRealmCardKey(uuid: String, key: String) -> CardKey {
        let cardKey = CardKey()
        
        cardKey.cardUUID = uuid
        cardKey.key = key
        
        return cardKey
    }
}





































