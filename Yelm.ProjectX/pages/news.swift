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
    
    @State private var phase: CGFloat = 0
    
    
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
                            NavigationLink(destination: story()){
                                VStack{
                                    URLImage(URL(string: object.thubnail)!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .frame(width: proxy.news.width-5, height: proxy.news.height-5)
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(15)
                                            .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                            .padding(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                                    .strokeBorder(style: StrokeStyle(
                                                        lineWidth: 2,
                                                        lineCap: .round,
                                                        lineJoin: .round,
                                                        dash: [10],
                                                        dashPhase: self.phase
                                                    ))
                                                    .foregroundColor(Color.theme)
                                                    .onAppear {
                                                        self.phase = 0
                                                        self.phase = -20
                                                    }
                                                    .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))

                                            )
                                        
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
