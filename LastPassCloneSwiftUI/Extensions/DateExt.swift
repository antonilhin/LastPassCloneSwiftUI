//
//  DateExt.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import Foundation

extension Date{
    func format(_ format: String = "E, d MMM yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.autoupdatingCurrent
        let component = formatter.string(from: self)
        return component
    }
}
