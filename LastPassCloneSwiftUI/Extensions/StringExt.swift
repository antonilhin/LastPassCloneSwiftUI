//
//  StringExt.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 05/05/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import Foundation

extension String {
    func getImageName() -> String {
        let urlComponents = self.lowercased().split(separator: ".")
        let count = urlComponents.count
        
        if urlComponents.isEmpty{
            return "placeholder"
        }
        return count > 2 ? String(urlComponents[count - 2]) : String(urlComponents.first ?? "")
    }
}

