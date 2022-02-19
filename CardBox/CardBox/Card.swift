//
//  Card.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/16.
//

import Foundation
import RealmSwift

//TODO: add func() for Object interaction?
//TODO: update schema caution (https://docs.mongodb.com/realm/sdk/swift/examples/modify-an-object-schema/)
struct CardCell: Hashable {
    var cardUUID: String = "" // primary key
    
    var cardTag: String = ""
    var cardTitle: String = ""
    var cardLocation: String = ""
    var cardDate: String = ""
    var cardContents: String = ""
}

class Card: Object {
    @Persisted(primaryKey: true) var cardUUID: String

    @Persisted var cardTitle: String
    @Persisted var cardTag: String
    @Persisted var cardLocation: String
    @Persisted var cardDate: String
    @Persisted var cardContents: String
    
    /*
    @Persisted var isPrivate: Bool
    @Persisted var isEncrypt: Bool
     @Persisted var isCloud: Bool
     @Persisted var isChecked: Bool
     */

}

class CardInfo: Object {
    @Persisted(primaryKey: true) var cardUUID: String
    
    @Persisted var isPrivate: Bool
    @Persisted var isEncrypt: Bool
    @Persisted var isCloud: Bool
    @Persisted var isChecked: Bool
}

//How to handle this key?
//FUTURE WORKS
class CardKey: Object {
	@Persisted(primaryKey: true) var cardUUID: String

	@Persisted var key: String
}

//for user defined tag
//FUTURE WORKS
class TagList: Object {
	@Persisted var tag: String
}
