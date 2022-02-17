//
//  PublicBox.swift
//  CardBox
//
//  Created by 하민종 on 2022/02/12.
//

import SwiftUI
import FoldingCell
import Combine
import RealmSwift

struct PublicBoxTabView: View {
    
    let realm = try! Realm()
    @State var publicCardInfoList: Results<CardInfo>
    @State var isExist: Bool = false
    
    init() {
        let cardInfoList = realm.objects(CardInfo.self)
        
        self.publicCardInfoList = cardInfoList.where {
			$0.isPrivate == false
		}
        
        if (self.publicCardInfoList.count > 0) {
            self.isExist = true
        }
    }
    
    var body: some View {
        if (self.isExist) {
            NavigationView {
                List {
                    ForEach(self.publicCardInfoList, id: \.self) { publicCardInfo in
                        let title = realm.object(ofType: Card.self, forPrimaryKey: publicCardInfo.cardUUID)?.cardTitle
                        Text(title ?? "UNKNOWN")
                    }
                    .onAppear(perform:  {
                        let cardInfoList = realm.objects(CardInfo.self)
                        
                        self.publicCardInfoList = cardInfoList.where {
                            $0.isPrivate == false
                        }
                        
                        if (self.publicCardInfoList.count > 0) {
                            self.isExist = true
                        }
                        
                    })
                }
                .navigationTitle("Public Box")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: OnDemandView(AddNewCardView())) {
                            Text("Add")
                        }
                    }
                }
            }
            .onAppear {
                let cardInfoList = realm.objects(CardInfo.self)
                
                self.publicCardInfoList = cardInfoList.where {
                    $0.isPrivate == false
                }
                
                if (self.publicCardInfoList.count > 0) {
                    self.isExist = true
                }
            }
        }
        else {
            NavigationView {
                VStack (alignment: .leading) {
                    Text("This is the Public Box which contains public cards!")
                        .foregroundColor(.none)
                    Text("Press 'Add' to write a new card!")
                }
                .padding()
                .navigationTitle("Public Box")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: OnDemandView(AddNewCardView())) {
                            Text("Add")
                        }
                    }
                }
            }
            .onAppear {
                let cardInfoList = realm.objects(CardInfo.self)
                
                self.publicCardInfoList = cardInfoList.where {
                    $0.isPrivate == false
                }
                
                if (self.publicCardInfoList.count > 0) {
                    self.isExist = true
                }
            }
        }
    }
}

struct PuplicBox_Previews: PreviewProvider {
    static var previews: some View {
        PublicBoxTabView()
    }
}
