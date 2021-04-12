//
//  feed.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 12.04.2021.
//

import Foundation
import SwiftUI
import Yelm_Server



struct Feed: View {
    
    var body: some View{
        VStack{
            
            HStack{
                Text("Новости")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .padding(.leading, 15)
            
            Feed_Item()
                .padding(.horizontal)
            
        }.padding(.bottom)
    }
    
}

