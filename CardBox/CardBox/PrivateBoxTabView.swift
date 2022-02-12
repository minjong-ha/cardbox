//
//  PrivateBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI

struct PrivateBoxTabView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 300, height: 300)
                .foregroundColor(.green)
            
            Text("Private")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}

struct PrivateBox_Previews: PreviewProvider {
    static var previews: some View {
        PrivateBoxTabView()
    }
}
