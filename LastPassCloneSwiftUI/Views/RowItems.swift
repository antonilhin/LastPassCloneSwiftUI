//
//  RowItems.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 28/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct RowItems: View {
    var body: some View {
        HStack{
            Image("note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("No name")
                    .font(.system(size: 20))
                    .padding(.bottom, 5)
                Text( "N/A")
                    .foregroundColor(Color.gray)
                    .font(.callout)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
            .background(Color.background)
            .cornerRadius(20)
            .neumorphic()
            .padding(.vertical)
        }
    }
}

struct RowItems_Previews: PreviewProvider {
    static var previews: some View {
        RowItems()
    }
}
