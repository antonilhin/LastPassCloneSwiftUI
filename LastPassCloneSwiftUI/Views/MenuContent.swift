//
//  MenuContent.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct MenuContent: View {
    
    private let icons = ["star.fill","shield.lefthalf.fill","briefcase.fill"]
    @Binding var showMenu: Bool
    @Binding var selectedScreen: Screens
    
    var body: some View {
        VStack(spacing: 30) {
            Image("singlePass-dynamic").resizable().aspectRatio(contentMode: .fit) .frame(height: 30)
                .padding()
            
            ForEach(0..<icons.count, id: \.self){ i in
                self.createMenuItem(icon: self.icons[i], screen: Screens.allCases[i])
            }
            
            Spacer()
            createMenuItem(icon: "gear", screen: .Settings)
            
        }
        .padding(.horizontal)
        .padding(.leading, UIScreen.main.bounds.width  * ( 1 - 1/1.5) )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .background(Color.background)
    }
    
    fileprivate func createMenuItem(icon: String, screen: Screens) -> MenuItem {
        return MenuItem(icon: icon , screen: screen, isSelected: .constant(self.selectedScreen == screen),onSelect: { selectedScreen in
            self.selectedScreen = selectedScreen
            withAnimation {
                self.showMenu = false
            }
        })
    }
}

struct MenuContent_Previews: PreviewProvider {
    static var previews: some View {
        MenuContent(showMenu: .constant(false), selectedScreen: .constant(Screens.Vault))
    }
}
