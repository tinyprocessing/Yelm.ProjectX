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

var forever_interpolating: Animation {
      Animation.interpolatingSpring(stiffness: 350, damping: 5, initialVelocity: 10)
          .repeatForever(autoreverses: false)
}

struct LoaderEnot: View {
    
    @State private var isAnimating = false
    @State private var show : Bool = false
    
    var body: some View {
        VStack{
            if (self.show){
            Image("enot")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                .animation(self.isAnimating ? .interpolatingSpring(mass: 1, stiffness: 1, damping: 0.7, initialVelocity: 2) : .default)
                .onAppear {
                    withAnimation() {
                        self.isAnimating = true
                    }
                    
                }
                .onDisappear {
                    withAnimation() {
                        self.isAnimating = false
                    }
                }
            }else{
                Image("enot")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
            }
        }.onAppear{
            self.show = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.show = true
            }
        }
    }
  
}
