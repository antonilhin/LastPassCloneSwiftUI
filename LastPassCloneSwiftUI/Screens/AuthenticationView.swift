//
//  AuthenticationView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 09/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var showCreateAccount = false
    
    private let accountCreationTransition = AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    private let loginTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    var body: some View {
        let accountCreationView = AccountCreationView(showLogin: self.$showCreateAccount)
        let loginView = LoginView(showCreateAccount: self.$showCreateAccount)
        
        return VStack {
            
            if showCreateAccount {
                accountCreationView.transition(accountCreationTransition)
            } else {
                loginView.transition(loginTransition)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}


