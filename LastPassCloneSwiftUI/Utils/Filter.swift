//
//  Filter.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 21/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import Foundation

enum Filter: String, CaseIterable{
    case AllItems = "All Items"
    case Passwords
    case Notes
    case MostUsed = "Most Used"
    case Favorites
}
