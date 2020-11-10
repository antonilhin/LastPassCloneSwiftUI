//
//  HomeView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 28/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var showEditFormView = false
    @ObservedObject var coredataManager = CoreDataManager.shared
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HeaderView { filter in }
                createList()
            }
            
            createFloatingButton()
        }
    }
    
    private func createList() -> some View {
        List{
            
            if self.coredataManager.showPasswords{
                createPasswordsSection()
            }
            
            if self .coredataManager.showNotes {
                createNotesSection()
            }
        }.onAppear {
            UITableView.appearance().backgroundColor = UIColor(named: "bg")
            UITableView.appearance().separatorColor = UIColor(named: "bg")
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    private func createPasswordsSection() -> some View {
        
        FetchResultWrapper(predicate: self.coredataManager.passwordPredicate, sortDescriptors: [self.coredataManager.sortDescriptor]) { (passwords: [PasswordItem]) in
            
            if !passwords.isEmpty {
                Section(header:
                            SectionTitle(title: "Passwords")
                ) {
                    ForEach(passwords.map { PasswordViewModel(passwordItem: $0) } ) { password in
                        RowItems(passwordModel: password).listRowBackground(Color.background)
                    }
                }
            }
        }
    }
    
    private func createNotesSection() -> some View {
        
        FetchResultWrapper(predicate: self.coredataManager.notePredicate, sortDescriptors: [self.coredataManager.sortDescriptor]) { (notes: [NoteItem]) in
            
            if !notes.isEmpty {
                Section(header:
                            SectionTitle(title: "Notes")
                ) {
                    ForEach(notes.map { NoteViewModel(noteItem: $0) } ) { note in
                        RowItems(noteModel: note).listRowBackground(Color.background)
                    }
                }
            }
        }
    }
    
    fileprivate func createFloatingButton() -> some View {
        
        Button(action: {
            HapticFeedback.generate()
            self.showEditFormView.toggle()
        }) {
            
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.text)
                .padding()
                .background(Color.background)
                .cornerRadius(35)
                .neumorphic()
        }
        .padding(30)
        .sheet(isPresented: self.$showEditFormView) {
            self.createEditFormView()
            
        }
    }
    
    fileprivate func createEditFormView() -> some View {
        EditFormView(showDetails: self.$showEditFormView)
            .padding(.bottom)
            .background(Color.background)
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
