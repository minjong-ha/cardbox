//
//  OnDemandView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/02/14.
//

import SwiftUI
import Combine

public struct OnDemandView<Content: View>: View {
    private let build: () -> Content

    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}

struct OnDemandView_Previews: PreviewProvider {
    static var previews: some View {
        //OnDemandView()
        ContentView()
    }
}
