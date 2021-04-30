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
    
    @State var selection: String? = nil

    
    var body: some View{
        VStack{
            
            HStack{
                Text("Новости")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .padding(.leading, 15)
            
            VStack(spacing: 25){
                
                NavigationLink(destination: Feed_Read(url: "https://lab.yelm.io",
                                                      name: "Лаборатория"),
                               tag: "feed",
                               selection:  $selection){
                    
                        Feed_Item()
                            .padding(.horizontal)
                }
            
            }
            
        }.padding(.bottom)
    }
    
}

