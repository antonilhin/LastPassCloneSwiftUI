//
//  SectionTitle.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 28/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct SectionTitle: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.leading, 40)
            .background(Color.background)
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(title: "Passwords")
    }
}
