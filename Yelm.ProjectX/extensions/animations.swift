//
//  animations.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import SwiftUI
import UIKit

var forever: Animation {
      Animation.linear(duration: 2.0)
          .repeatForever(autoreverses: false)
}


struct LoaderEnot: View {
    
    @State private var isAnimating = false

    
    var body: some View {
        VStack{
            Image("enot")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                .animation(self.isAnimating ? .interpolatingSpring(mass: 1, stiffness: 1, damping: 0.7, initialVelocity: 2) : .default)
                .onAppear { self.isAnimating = true }
                .onDisappear { self.isAnimating = false }
        }
    }
}
