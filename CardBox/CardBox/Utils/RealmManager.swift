//
//  RealmWorker.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/28.
//

import SwiftUI
import RealmSwift

class RealmObjectManager {
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
    
    func realmCardDelete(card: Card) {
        try! realm.write {
            realm.delete(card)
        }
    }
    
    func realmCardInfoDelete(cardInfo: CardInfo) {
        try! realm.write {
            realm.delete(cardInfo)
        }
    }
    
    func realmCardKeyDelete(cardKey: CardKey) {
        try! realm.write {
            realm.delete(cardKey)
        }
    }
    
    func getRealmCardList() -> Results<Card>? {
        let cardList = realm.objects(Card.self)
        
        if (cardList.count == 0) { return nil }
        else { return cardList }
    }
    
    func getRealmCardInfoList() -> Results<CardInfo>? {
        let cardInfoList = realm.objects(CardInfo.self) // return objects
        
        if (cardInfoList.count == 0) { return nil}
        else { return cardInfoList }
    }
    
    func getRealmCardKeyList() -> Results<CardKey>? {
        let cardKeyList = realm.objects(CardKey.self)
        
        if (cardKeyList.count == 0) { return nil }
        else { return cardKeyList }
    }
    
    func getRealmCard(uuid: String) -> Object? {
        let card = realm.object(ofType: Card.self, forPrimaryKey: uuid)
        
        if (card == nil) { return nil }
        else { return card! }
    }
    
    func getRealmCardInfo(uuid: String) -> Object? {
        let cardInfo = realm.object(ofType: CardInfo.self, forPrimaryKey: uuid)
        
        if(cardInfo == nil) { return nil }
        else { return cardInfo!}
    }
    
    func getRealmCardKey(uuid: String) -> Object? {
        let cardKey = realm.object(ofType: CardKey.self, forPrimaryKey: uuid)
        
        if(cardKey == nil) { return nil }
        else { return cardKey! }
    }
    
    func getRealmPublicCardInfoList() -> Results<CardInfo>? {
        let cardInfoList = self.getRealmCardInfoList()
        if(cardInfoList!.count == 0) { return nil }
        
        let publicCardInfoList = cardInfoList!.where { $0.isPrivate == false }
        if(publicCardInfoList.count == 0) { return nil }
        
        return publicCardInfoList
    }
    
    func initRealmCard(uuid: String, title: String, tag: String, location:String, date: String, contents: String) -> Card {
        let card = Card()
        
        card.cardUUID = uuid
        card.cardTitle = title
        card.cardTag = tag
        card.cardLocation = location
        card.cardDate = date
        card.cardContents = contents
        
        return card
    }
    
    func initRealmCardInfo(uuid: String, isPrivate: Bool, isEncrypt: Bool, isCloud: Bool, isChecked: Bool) -> CardInfo {
        let cardInfo = CardInfo()
        
        cardInfo.cardUUID = uuid
        cardInfo.isPrivate = isPrivate
        cardInfo.isEncrypt = isEncrypt
        cardInfo.isCloud = isCloud
        cardInfo.isChecked = isChecked
        
        return cardInfo
    }
    
    func initRealmCardKey(uuid: String, key: String) -> CardKey {
        let cardKey = CardKey()
        
        cardKey.cardUUID = uuid
        cardKey.key = key
        
        return cardKey
    }
}





































