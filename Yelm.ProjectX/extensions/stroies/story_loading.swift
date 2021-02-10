//
//  story_loading.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.02.2021.
//

import Foundation
import SwiftUI


struct loading_story: View {
    
    var progress:CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .cornerRadius(5)
                Rectangle()
                    .frame(width: geometry.size.width * self.progress, height: nil, alignment: .leading)
                    .foregroundColor(Color.white.opacity(0.9))
                    .cornerRadius(5)
            }
        }
    }
}
