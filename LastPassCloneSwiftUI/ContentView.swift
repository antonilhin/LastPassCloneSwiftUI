//
//  ContentView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var showMenu = false
    @State var selectedScreen: Screens = .Vault
    @GestureState private var  translation: CGFloat = 0
    private let triggerLocation = UIScreen.main.bounds.width - 50
    var offset: CGFloat {
        return showMenu ? UIScreen.main.bounds.width / 1.5 : 0
    }
    
    var body: some View {
        
        ZStack{
            if authManager.isLoggedIn{
                createMenuContent()
                VStack {
                    NavBar(showMenu: self.$showMenu, title: selectedScreen.rawValue, showSearchField: selectedScreen == .Vault)
                    if selectedScreen == .Vault{
                        HomeView().transition(.opacity)
                    }
                    
                    if selectedScreen == .Premium{
                        GoPremiumView()
                    }
                    
                    if selectedScreen == .Security{
                        SecurityView()
                    }
                    
                    if selectedScreen == .Settings{
                        SettingsView()
                    }
                    
                }
                .background(Color.background)
                .clipped()
                .shadow(color:  showMenu ? .darkShadow : .clear, radius: showMenu ? 6 : 0, x: 3, y: 0)
                .offset(x:  -max(self.offset + self.translation, 0), y: 0)
                .animation(.spring(), value: showMenu)
                .gesture( handleGesture() )
            } else {
                AuthenticationView()
            }
        }
        .background(Color.background)
        .edgesIgnoringSafeArea(.all)
    }
    
    fileprivate func createMenuContent() -> some View {
        return MenuContent(showMenu: self.$showMenu, selectedScreen: self.$selectedScreen)
            .padding(.top, 40).padding(.bottom, 65)
            
            .rotation3DEffect(Angle(degrees: 30 - Double(30 * dragPercent())) , axis: (x: 0, y: 1, z: 0))
            .offset(x: 100 - (100 * dragPercent()), y: 0)
            .animation(.spring(), value: showMenu)
            .onTapGesture {
                if self.showMenu { HapticFeedback.generate() }
                self.showMenu = false
                
            }
    }
    
    fileprivate func dragPercent() -> CGFloat {
             min(1,(self.offset +  self.translation) / (UIScreen.main.bounds.width / 1.5))
        }
           
    fileprivate func handleGesture() -> _EndedGesture<GestureStateGesture<DragGesture, CGFloat>> {
            return DragGesture().updating(self.$translation, body: { (value, state, transaction) in
                if value.startLocation.x > self.triggerLocation {
                    state = -value.translation.width
                }
            }
            ).onEnded({ value in
                guard value.startLocation.x > self.triggerLocation else { return }
                HapticFeedback.generate()
                self.showMenu = value.translation.width < 0
            })
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = AuthenticationManager()
        auth.isLoggedIn = true
        return ContentView().environmentObject(auth)
    }
}
