//
//  MenuItem.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct MenuItem: View {
    var icon: String = "briefcase.fill"
    var screen: Screens = .Vault
    @Binding var isSelected: Bool
    var onSelect: ((Screens)->()) = {_ in}
    
    var body: some View {
        
        Button(action: {
            HapticFeedback.generate()
            self.onSelect(self.screen)
        }) {
            HStack {
                Image(systemName: icon).imageScale(.large).foregroundColor(isSelected ? .accent : .gray)
                Spacer()
                Text(screen.rawValue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(isSelected ? .accent : .gray)
            }.padding()
            .background(Color.background)
            .cornerRadius(20).modifier(NeumorphicEffect())
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(isSelected: .constant(false))
    }
}

