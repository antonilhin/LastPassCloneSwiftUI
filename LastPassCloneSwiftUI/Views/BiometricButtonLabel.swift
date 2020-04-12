//
//  BiometricButtonLabel.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 12/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct BiometricButtonLabel: View {
    var icon = "touchID"
    var text = "Use touch ID"
    
    var body: some View {
        VStack {
            Image("touchID" )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("Use touch ID")
        }.foregroundColor(Color.accent)
    }
}


struct BiometricButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        BiometricButtonLabel()
    }
}

