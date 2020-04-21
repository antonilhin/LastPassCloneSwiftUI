//
//  HeaderView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 21/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    
    @State private var selectedFilter = Filter.AllItems
    var onSelect: ((Filter)->()) = {_ in }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(Filter.allCases, id: \.self){ filter in
                    FilterView(filter: filter, isSelected: .constant(self.selectedFilter == filter), onSelect: { selected in
                        withAnimation(.spring()) {
                            self.selectedFilter = selected
                        }
                        
                        self.onSelect(selected)
                    })
                }
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
