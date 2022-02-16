//
//  Card.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/16.
//

import Foundation
import RealmSwift

//TODO: consider the Object structure. Remember, changing Object struct is impossible as I know...
//TODO: add func() for Object interaction?
//TODO: test can change Object class structure in live service
class Card: Object {
    @Persisted(primaryKey: true) var cardUUID: String

    @Persisted var cardTitle: String
    @Persisted var cardTag: String
    @Persisted var cardLocation: String
    @Persisted var cardDate: String
    @Persisted var cardContents: String
}    

//TODO: change the class name for more better....
class Authority: Object {
	@Persisted(primaryKey: true) var cardUUID: String

	@Persisted var isPrivate: Bool
	@Persisted var isEncrypt: Bool
	@Persisted var isCloud: Bool
}

//How to handle this key?
class Security: Object {
	@Persisted(primaryKey: true) var cardUUID: String

	@Persisted var key: String
}
