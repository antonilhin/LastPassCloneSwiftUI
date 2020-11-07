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
            createPasswordsSection()
            createNotesSection()
        }
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(named: "bg")
            UITableView.appearance().separatorColor = .clear
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    private func createPasswordsSection() -> some View {
        Section(header:
            SectionTitle(title: "Passwords")
        ) {
            ForEach(1..<5) { i in
                RowItems().listRowBackground(Color.background)
            }
        }
    }
    
    private func createNotesSection() -> some View {
        Section(header:
            SectionTitle(title: "Notes")
        ) {
            ForEach(1..<5) { i in
                RowItems().listRowBackground(Color.background)
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
        }.padding(30)
        .sheet(isPresented: self.$showEditFormView) {
            self.createEditFormView()
        }
    }
    
    fileprivate func createEditFormView() -> some View {
        EditFormView(showDetails: .constant(false))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
