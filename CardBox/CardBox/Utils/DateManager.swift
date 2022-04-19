//
//  DateManager.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/30.
//

import SwiftUI

class DateManager {
    func getStringfromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func getDatefromString() {
        
    }
}
