//
//  BoxManager.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/07/12.
//

import Foundation
import RealmSwift

class BoxManager {
    //var colorScheme = ""
    
    private let realm = try! Realm()
    
    private var tagList: Array<String> = []
    private var sectionList: Array<SectionCell> = []
    
    private var isExist: Bool = false
    private var isEditing: Bool = false
    
    private var searchText: String = ""
    private var searchTag: String = ""
    
    func loadCards() {
        print("loadCards()")
    }
    
    func deleteCard() {
        print("deleteCard()")
    }
    
}
