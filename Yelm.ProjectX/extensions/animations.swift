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
        if (distribution == false){
            VStack{
//                if (self.show){
//                Image("logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 80)
//                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
//                    .animation(self.isAnimating ? .interpolatingSpring(mass: 1, stiffness: 1, damping: 0.7, initialVelocity: 2) : .default)
//                    .onAppear {
//                        withAnimation() {
//                            self.isAnimating = true
//                        }
//
//                    }
//                    .onDisappear {
//                        withAnimation() {
//                            self.isAnimating = false
//                        }
//                    }
//                }else{
                Image(uiImage: Bundle.main.icon!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(15)
                        .shadow(color: Color.secondary.opacity(0.4), radius: 6, x: 6, y: 6)
//                }
            }.onAppear{
                self.show = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    self.show = true
                }
            }
        }else{
            VStack{
                
                Image(uiImage: Bundle.main.icon!)
                    .resizable()
                    .cornerRadius(15)
                    .frame(width: 75, height: 75)
                    .padding(.vertical, 30)
                    .shadow(color: Color.secondary.opacity(0.4), radius: 6, x: 6, y: 6)
                
                ActivityIndicator()
                    .frame(CGSize(width: 60, height: 60))
                    .foregroundColor(.theme)
                
            }
        }
    }
  
}


struct ActivityIndicator: View {

  @State private var isAnimating: Bool = false

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<5) { index in
        Group {
          Circle()
            .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
            .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
            .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
          }.frame(width: geometry.size.width, height: geometry.size.height)
            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
            .animation(Animation
              .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
              .repeatForever(autoreverses: false))
        }
      }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
        self.isAnimating = true
    }
  }
}
