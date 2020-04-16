//
//  AccountCreationView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 09/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct AccountCreationView: View {
    
    @Binding var showLogin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var formOffset: CGFloat = 0
    @EnvironmentObject private var authManager: AuthenticationManager
    
    @State private var showAlert = false
    
    fileprivate func goToLoginButton() -> some View {
        return Button(action: {
            self.authManager.email = ""
            self.authManager.password = ""
            self.authManager.confirmedPassword = ""
            withAnimation(.spring() ) {
                self.showLogin.toggle()
            }
        }) {
            HStack {
                Text("Login")
                    .accentColor(Color.darkerAccent)
                Image(systemName: "arrow.right.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(Color.darkerAccent)
                
            }
        }
    }
    
    fileprivate func createContent() -> some View{
        VStack {
            Image("singlePass-dynamic").resizable().aspectRatio(contentMode: .fit) .frame(height: 30)
                .padding(.bottom)
            VStack(spacing: 10) {
                Text("Create Account").font(.title).bold()
                VStack(spacing: 30) {
                    SharedTextfield(value: self.$authManager.email,header: "Email", placeholder: "Your primary email",errorMessage: authManager.emailValidation.message)
                    PasswordField(value: self.$authManager.password,header: "Password",  placeholder: "Make sure it's string",errorMessage: authManager.passwordValidation.message,  trailingIconName: "doc.on.clipboard.fill" ,isSecure: true)
                    PasswordField(value: self.$authManager.confirmedPassword,header: "Confirm Password",  placeholder: "Must match the password", errorMessage: authManager.confirmedPasswordValidation.message, trailingIconName: "doc.on.clipboard.fill", isSecure: true)
                    Text(self.authManager.similarityValidation.message).foregroundColor(Color.red)
                    
                }
                LCButton(text: "Sign up", backgroundColor: self.authManager.canSignup ? Color.accent : Color.gray ) {
                    self.showAlert = !self.authManager.createAccount()
                }
                .disabled(!self.authManager.canSignup)
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("Error") , message: Text("Oops! Seems like there's already an account associated with this device. You need to login instead.") , dismissButton: .default(Text("Ok")) )
                }
                
            }.modifier(FormModifier()).offset(y: self.formOffset)
            
            goToLoginButton()
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(showLogin: .constant(false))
    }
}
