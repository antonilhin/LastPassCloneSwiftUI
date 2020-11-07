//
//  GoPremiumView.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 07/11/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI

struct GoPremiumView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                HStack {
                    Text("SinglePass").font(.title)
                    Text("Premium").font(.title).bold()
                }
                
                Text("Take your productivity to the next lavel")
                
                LCButton(text: "Go Premium", backgroundColor: .accent) { }
                
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")
            }.padding()
            .padding(.vertical)
        }
    }
}

struct GoPremiumView_Previews: PreviewProvider {
    static var previews: some View {
        GoPremiumView()
    }
}
