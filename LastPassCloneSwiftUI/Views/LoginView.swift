//
//  LoginView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 09/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    
    @Binding var showCreateAccount: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var formOffset: CGFloat = 0
    
    @EnvironmentObject private var authManager: AuthenticationManager
    
    fileprivate func createAccountButton() -> some View {
        return Button(action: {
            withAnimation(.spring()) {
                self.showCreateAccount.toggle()
            }
        }) {
            HStack {
                Image(systemName: "arrow.left.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(Color.darkerAccent)
                Text("Create account")
                    .accentColor(Color.darkerAccent)
            }
        }
    }
    
    fileprivate func createContent() -> some View {
        return VStack {
            Image("singlePass-dynamic").resizable().aspectRatio(contentMode: .fit) .frame(height: 30)
                .padding(.bottom)
            
            VStack(spacing: 30) {
                Text("Login").font(.title).bold()
                VStack(spacing: 30) {
                    SharedTextfield(value: self.$authManager.email, header: "Email" , placeholder: "Your email",errorMessage: authManager.emailValidation.message)
                    PasswordField(value: self.$authManager.password, header: "Master Password", placeholder: "Master password goes here...", errorMessage: authManager.passwordValidation.message , isSecure: true)
                    
                    LCButton(text: "Login", backgroundColor: self.authManager.canLogin ? Color.accent : Color.gray) {
                        _ = self.authManager.authenticate()
                    }
                    
                    if self.authManager.hasAccount(){
                        Button(action: {
                            self.authManager.authenticateWithBiometric()
                        }) {
                            
                            if self.authManager.biometryType == LABiometryType.faceID{
                                VStack {
                                    Image(systemName: "faceid" )
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text("Use face ID")
                                }.foregroundColor(Color.accent)
                            }
                            
                            if self.authManager.biometryType == LABiometryType.touchID{
                                VStack {
                                    Image("touchID" )
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text("Use touch ID")
                                }.foregroundColor(Color.accent)
                            }
                        }
                    }
                }
            }.modifier(FormModifier()).offset(y: self.formOffset)
            createAccountButton()
        }
    }
    
    var body: some View {
        SubscriptionView(content: createContent(), publisher: NotificationCenter.keyboardPublisher) { frame in
            withAnimation {
                self.formOffset = frame.height > 0 ? -200 : 0
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showCreateAccount: .constant(false))
    }
}
