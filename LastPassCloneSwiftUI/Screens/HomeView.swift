//
//  HomeView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 28/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HeaderView { filter in }
            createList()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
