//
//  FormModifier.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 09/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct FormModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.padding()
            .background(Color.background)
            .cornerRadius(10)
            .padding()
            .neumorphic()
    }
}
