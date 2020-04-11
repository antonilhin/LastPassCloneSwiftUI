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
    
    var body: some View {
        
        ZStack{
            if authManager.isLoggedIn{
                Text("Coming soon").font(.title).bold()
            } else {
                AuthenticationView()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
