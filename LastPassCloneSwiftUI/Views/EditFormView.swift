//
//  EditFormView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 05/05/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct EditFormView: View {
    
    var passwordModel: PasswordViewModel?
    var noteModel: NoteViewModel?
    @ObservedObject var coredataManager = CoreDataManager.shared
    
    @Binding var showDetails: Bool
    @State private var showPasswordGeneratorView = false
    
    @State private var username = ""
    @State private var password = ""
    @State private var website = ""
    @State private var passwordNote = ""
    @State private var noteName = ""
    @State private var noteContent = ""
    @State private var favoriteImage = "heart"
    
    
    @State private var formType = FormType.Password
    @State private var formOffsetY: CGFloat = 0
    
    var body: some View {
        SubscriptionView(content:  createBodyContent(), publisher: NotificationCenter.keyboardPublisher) { rect in
            withAnimation {
                self.formOffsetY = rect.height > 0 ? -150 : 0
            }
        }
        
    }
    
    fileprivate func createBodyContent() -> some View {
        VStack {
            FormHeader(showDetails: self.$showDetails, formType: self.$formType)
            ScrollView {
                VStack {
                    if formType == FormType.Password{
                        createPasswordForm()
                    }
                    else {
                        createNoteForm()
                    }
                    
                    HStack(spacing: 20) {
                        createSaveButton()
                        createHeartButton()
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
        .background(Color.background)
        .cornerRadius(20)
        .padding().padding(.top, 40)
        .neumorphic()
        .offset(x: 0, y: self.formOffsetY)
    }
    
    
    
    fileprivate func createNoteForm() -> some View{
        VStack(spacing: 40) {
            SharedTextfield(value: self.$noteName, header: "Title",placeholder: "Your note title goes here")
            SharedTextfield(value: self.$noteContent, header: "Note",placeholder: "You can write anything here...", showUnderline: false)
            
        }.padding()
    }
    
    fileprivate func createPasswordForm()-> some View{
        VStack(spacing: 40) {
            SharedTextfield(value: self.$username)
            VStack(alignment: .leading) {
                PasswordField(value: self.$password, header: "Password",placeholder: "Make sure the password is secure")
                
                Button(action: {
                    self.showPasswordGeneratorView.toggle()
                }) {
                    Text("Generate password")
                        .foregroundColor(.accent)
                }.sheet(isPresented: self.$showPasswordGeneratorView) {
                    PasswordGeneratorView(generatedPassword: self.$password)
                }
            }
            SharedTextfield(value: self.$website, header: "Website", placeholder: "https://")
            SharedTextfield(value: self.$passwordNote, header: "Note",placeholder: "You can write anything here...", showUnderline: false)
        }.padding()
    }
    
    fileprivate func createSaveButton() -> LCButton {
        return LCButton(text: "Save", backgroundColor: Color.accent) {
            switch self.formType{
            case .Password:
                self.saveNewPassword()
            case .Note:
                self.saveNewNote()
            }
        }
    }
    
    fileprivate func createHeartButton() -> some View {
        
        Button(action: {
            
        }) {
            Image(systemName: self.favoriteImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .foregroundColor( favoriteImage == "heart" ? Color.gray : Color.orange)
        }
    }
    
    fileprivate func saveNewPassword() {
        if self.passwordModel == nil{
            if !username.isEmpty
                && !password.isEmpty
                && !website.isEmpty {
                let password = PasswordItem(context: coredataManager.context)
                password.createdAt = Date()
                password.id = UUID()
                password.isFavorite = false
                password.lastUsed = Date()
                password.note = self.passwordNote
                password.site = self.website.lowercased()
                password.username = self.username
                password.password = self.password
                _ = coredataManager.save()
                
                withAnimation {
                    self.showDetails = false
                }
            }
        }
    }
    
    fileprivate func saveNewNote() {
        if self.noteModel == nil {
            
            if !self.noteName.isEmpty && !self.noteContent.isEmpty {
                let note = NoteItem(context: coredataManager.context)
                note.id = UUID()
                note.isFavorite = false
                note.createdAt = Date()
                note.lastUsed = Date()
                note.name = noteName
                note.content = noteContent
                _ = coredataManager.save()
                withAnimation {
                    self.showDetails = false
                }
            }
        }
    }
}


struct EditFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditFormView(showDetails: .constant(false))
    }
}
