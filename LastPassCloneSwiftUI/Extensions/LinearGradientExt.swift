//
//  LinearGradientExt.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 11/05/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
