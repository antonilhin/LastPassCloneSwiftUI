//
//  SecurityView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct SecurityView: View {
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                ForEach(0..<4, id: \.self) { i in
                    VStack {
                        HStack {
                            Text(SettingItems.allCases[i].rawValue).padding()
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        if i < 3{
                            Rectangle().frame(height: 0.5).foregroundColor(Color.gray)
                        }
                    }.padding(.horizontal)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.background).cornerRadius(20)
            .padding(10)
            .padding(.vertical)
            .modifier(NeumorphicEffect())
        }
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityView()
    }
}
