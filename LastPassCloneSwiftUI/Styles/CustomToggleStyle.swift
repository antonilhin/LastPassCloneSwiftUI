//
//  CustomToggleStyle.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 11/05/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color = .background
    var offColor: Color = .darkerAccent
    var size: CGFloat = 40
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        HStack {
            configuration.label
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
            }) {
                if configuration.isOn {
                    ZStack {
                        Circle()
                            .fill(Color.background)
                            .frame(width: size, height: size)
                            .innerShadow(radius: 1, colors: (Color.darkShadow, Color.lightShadow))
                        
                        Image(systemName: "power")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.accent)
                    }
                } else {
                    ZStack {
                        Circle()
                            .frame(width: size, height: size)
                            .foregroundColor(Color.background)
                        
                        Image(systemName: "power")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.gray)
                        
                    }.cornerRadius(size / 2).neumorphic()
                }
            }
        }
    }
}
