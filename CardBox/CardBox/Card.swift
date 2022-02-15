//
//  Card.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/16.
//

import Foundation
import RealmSwift

class Card: Object {
    @Persisted var cardUUID: String
    @Persisted var cardTitle: String
    @Persisted var cardTag: String
    @Persisted var cardLocation: String
    @Persisted var cardDate: String
    @Persisted var cardContents: String
    
    @Persisted var isPrivate: Bool
    @Persisted var isEncrypt: Bool
    @Persisted var isCloud: Bool
    
    override static func primaryKey() -> String? {
        return "cardUUID"
    }
}

