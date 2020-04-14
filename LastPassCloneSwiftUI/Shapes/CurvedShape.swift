//
//  CurvedShape.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 14/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 25
        var path = Path()
        
        path.move(to:  CGPoint.zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - cornerRadius), control: CGPoint(x: rect.midX , y: rect.height))
        
        path.closeSubpath()
        
        return path
    }
}
