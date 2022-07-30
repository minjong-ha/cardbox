//
//  SectionTitleView.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/26.
//

import SwiftUI

struct SectionTitleView: View {
    @Environment (\.colorScheme) var colorScheme
    
    @State var sectionTitle: String
    @Binding var isVisible: Bool
    @Binding var cardList: Array<CardCell>
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.isVisible.toggle()
                }
            }) {
               Text(self.sectionTitle)
                    .bold()
                    .font(.title2)
            }
            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            
            Spacer() // for the button trailing
            
            Menu {
                Button(action: {
                    withAnimation {
                        self.cardList.sort {
                            $0.cardTitle < $1.cardTitle
                        }
                    }
                }) {
                    Text("Title Ascending")
                }
                Button(action: {
                    withAnimation {
                        self.cardList.sort {
                            $0.cardTitle > $1.cardTitle
                        }
                    }
                }) {
                    Text("Title Descending")
                }
                Button(action: {
                    withAnimation {
                        self.cardList.sort {
                            $0.cardDate < $1.cardDate
                        }
                    }
                }) {
                    Text("Date Ascending")
                }
                Button(action: {
                    withAnimation {
                        self.cardList.sort {
                            $0.cardDate > $1.cardDate
                        }
                    }
                }) {
                    Text("Date Descending")
                }
                
            } label : {
                Image(systemName: "arrow.up.arrow.down.square")
            }
            
            Button (action: {
                withAnimation {
                    self.isVisible.toggle()
                }
            }) {
                Image(systemName: self.isVisible ? "chevron.down" : "chevron.right")
            }
        }
    }
}

