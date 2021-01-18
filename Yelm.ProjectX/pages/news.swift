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
            HStack{
                Text("Что выбрать?")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Spacer()
            }.padding(.leading, 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 0){
                    ForEach(self.news.news, id: \.self){ object in
                        NavigationLink(destination: EmptyView(), tag: 12, selection:  $selection){
                            VStack{
                            URLImage(URL(string: object.images[0])!) { proxy in
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
        .padding(.bottom, 20)
        .onAppear{
            
        }
    }
}
