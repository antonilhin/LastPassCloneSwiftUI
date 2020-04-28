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
    var body: some View {
        
        ZStack{
            if authManager.isLoggedIn{
                VStack {
                    NavBar(showMenu: self.$showMenu)
                    HomeView()
                }
            } else {
                AuthenticationView()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.background)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = AuthenticationManager()
        auth.isLoggedIn = true
        return ContentView().environmentObject(auth)
    }
}
