//
//  ViewExt.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 11/05/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

extension View {
    func innerShadow(radius: CGFloat, colors: (dark: Color, light:Color)) -> some View {
        self.overlay(
            Circle()
                .stroke(colors.dark, lineWidth: 4)
                .blur(radius: radius)
                .offset(x: radius, y: radius)
                .mask(Circle().fill(LinearGradient(colors.dark, Color.clear)))
        )
            .overlay(
                Circle()
                    .stroke(colors.light, lineWidth: 8)
                    .blur(radius: radius)
                    .offset(x: -radius, y: -radius)
                    .mask(Circle().fill(LinearGradient(Color.clear, colors.dark)))
        )
    }
}
