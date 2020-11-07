//
//  FetchResultWrapper.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI
import CoreData

struct FetchResultWrapper<Object, Content>: View where Object: NSManagedObject, Content: View {
    
    let content: ([Object]) -> Content
    var request: FetchRequest<Object>
    
    init(
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping ([Object]) -> Content
    ) {
        self.content = content
        self.request = FetchRequest(
            entity: Object.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
    }
    var body: some View {
        self.content(request.wrappedValue.map({$0}))
    }
}
