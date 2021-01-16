//
//  news.swift
//  Yelm.ProjectX
//
//  Created by Michael on 16.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server

struct News : View {
    
    @State var news : [String] = ["https://www.delivery-club.ru/pcs/selections/img_5fd9ed6ec43e37.97408392_orig.jpg?resize=fit&width=2048&height=162&gravity=ce&out=webp", "https://www.delivery-club.ru/pcs/selections/img_5f6e03b6d12dc7.58964341_orig.jpg?resize=fit&width=2048&height=162&gravity=ce&out=webp", "https://www.delivery-club.ru/pcs/selections/img_5fd3485d763ae2.16057645_orig.jpg?resize=fit&width=2048&height=162&gravity=ce&out=webp", "https://www.delivery-club.ru/pcs/selections/img_5fc52afd906468.94679436_orig.jpg?resize=fit&width=2048&height=162&gravity=ce&out=webp"]
    
    var body: some View{
        VStack(spacing: 10){
            HStack{
                Text("Что выбрать?")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Spacer()
            }.padding(.leading, 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 0){
                    ForEach(self.news, id: \.self){ object in
                        VStack{
                            URLImage(URL(string: object)!) { proxy in
                                proxy.image
                                    .resizable()
                                    .frame(width: proxy.news.width, height: proxy.news.height)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(15)
                                    .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                  
                            }
                        }.padding(.trailing, 15)
                        
                        
                    }
                }
                .padding(.leading, 15)
                .padding(.top, 15)
               
            }.frame(height: 110)
        }
        .padding(.bottom, 15)
        .onAppear{
            
        }
    }
}
