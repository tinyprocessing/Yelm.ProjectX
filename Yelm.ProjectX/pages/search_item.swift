//
//  search_item.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server



struct SearchItem : View {
    
    
    @State var title : String
    @State var image : String
    @State var price : String
    @State var type : String
    @State var quanity : String
    
     var body: some View {
        VStack{
            HStack(spacing: 0){
                
                
                URLImage(URL(string: image)!) { proxy in
                      proxy.image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                Text(title)
                    .lineLimit(2)
                    .padding(.leading, 10)
                
                Spacer()
                
                VStack{
                    Text("\(price) \(ServerAPI.settings.symbol)")
                        .foregroundColor(.secondary)
                       
                    
                    Text("\(quanity) / \(type) ")
                        .foregroundColor(.secondary)
                       
                } .padding(.horizontal, 10)
                
            
                
                Image(systemName: "chevron.right")
            }.padding([.top, .bottom], 5)
            Divider()
        }
    }
}
