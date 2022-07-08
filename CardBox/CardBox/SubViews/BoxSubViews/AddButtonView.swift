//
//  AddButtonView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/26.
//

import SwiftUI

struct AddButtonView: View {
    var body: some View {
        NavigationLink(destination: OnDemandView(AddNewCardView())) {
            Text("Add")
        }
    }
}
