//
//  feed_item.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 12.04.2021.
//

import Foundation
import SwiftUI
import Yelm_Server



struct Feed_Item: View {
        
    var body: some View{

        VStack(alignment: .leading, spacing: 10){
            
            ZStack(alignment: .topTrailing){
                Image("yelm_news")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(15)
                
                Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .padding(10)
            }
            
        }
    }
       
}
