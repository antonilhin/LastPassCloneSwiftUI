//
//  SettingsView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                ForEach(0..<6, id: \.self) { i in
                    VStack {
                        HStack {
                            Text(SettingItems.allCases[i].rawValue).padding()
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        if i < 5{
                            Rectangle().frame(height: 0.5).foregroundColor(Color.gray)
                        }
                    }.padding(.horizontal)
                    
                }
            }.frame(maxWidth: .infinity)
            .background(Color.background).cornerRadius(20)
            .padding(10)
            .modifier(NeumorphicEffect())
            
            VStack(spacing: 0){
                ForEach(6..<8, id: \.self) { i in
                    VStack {
                        HStack {
                            Text(SettingItems.allCases[i].rawValue).padding()
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        if i < 7{
                            Rectangle().frame(height: 0.5).foregroundColor(Color.gray)
                        }
                    }.padding(.horizontal)
                    
                }
            }.frame(maxWidth: .infinity)
            .background(Color.background).cornerRadius(20)
            .padding(10)
            .modifier(NeumorphicEffect())
            
            VStack {
                HStack {
                    Text(SettingItems.PrivacyPolicy.rawValue).foregroundColor(Color.accent).padding()
                    Spacer()
                    Image(systemName: "doc.on.doc.fill").foregroundColor(Color.accent)
                }
            }.padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color.background).cornerRadius(20)
            .padding(10)
            .modifier(NeumorphicEffect())
            
            VStack {
                HStack {
                    Text(SettingItems.LogOut.rawValue).foregroundColor(Color.red).padding()
                    Spacer()
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.orange)
                }
            }.padding(.horizontal)
            
            .frame(maxWidth: .infinity)
            .background(Color.background).cornerRadius(20)
            .padding(10)
            
            .modifier(NeumorphicEffect())
        }
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(named: "bg")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
