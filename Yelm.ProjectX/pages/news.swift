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
    
    @ObservedObject var news : news = GlobalNews
    @State var selection: Int? = nil
    
    var body: some View{
        VStack(spacing: 10){
            if (self.news.news.count > 0){
                HStack{
                    Text("Что выбрать?")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    
                    Spacer()
                }.padding(.leading, 15)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 0){
                        ForEach(self.news.news, id: \.self){ object in
                            NavigationLink(destination: NewsSingle()){
                                VStack{
                                URLImage(URL(string: object.thubnail)!) { proxy in
                                    proxy.image
                                        .resizable()
                                        .frame(width: proxy.news.width, height: proxy.news.height)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(15)
                                        .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                      
                                }
                            }.padding(.trailing, 15)
                            }.buttonStyle(ScaleButtonStyle())
                            
                            .simultaneousGesture(TapGesture().onEnded{
                                let news = object
                                self.news.news_single = news
                            })
                            
                            
                        }
                    }
                    .padding(.leading, 15)
                    .padding(.top, 15)
                   
                }.frame(height: 110)
                
            }
          
        }
        .padding(.bottom, self.news.news.count > 0 ? 20 : 0)
        .onAppear{
            
        }
    }
}
