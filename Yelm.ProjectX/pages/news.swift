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
    
    @State private var phase: CGFloat = 1
    
    
    var body: some View{
        VStack(spacing: 10){
            if (self.news.news.count > 0){
                HStack{
                    Text("Что выбрать?")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    
                    Spacer()
                }
                .padding(.leading, 15)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 0){
                        ForEach(self.news.news, id: \.self){ object in
                            if (object.type == "story"){
                                NavigationLink(destination:  story(), tag: object.id, selection: $selection){

                                    VStack{
                                        URLImage(URL(string: object.thubnail)!) { proxy in
                                            proxy.image
                                                .resizable()
                                                .frame(width: proxy.news.width-7, height: proxy.news.height-7)
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
                                                            miterLimit: 0,
                                                            dash: [10],
                                                            dashPhase: self.phase
                                                        ))
                                                        .foregroundColor(Color.theme)
                                                        .onAppear {
                                                            self.phase = 1
                                                            self.phase = -20
                                                        }
                                                        .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))

                                                )

                                        }
                                    }.padding(.trailing, 10)

                                }.buttonStyle(ScaleButtonStyle())
//                                .background(Color.blue)

                                .simultaneousGesture(TapGesture().onEnded{
                                    print("story tapped")
                                    let news = object
                                    self.news.news_single = news
                                })
                            }
                            
                            if (object.type == "news"){
                                NavigationLink(destination:  NewsSingle(), tag: object.id+1, selection: $selection ){
                                    
                                    VStack{
                                        URLImage(URL(string: object.thubnail)!) { proxy in
                                            proxy.image
                                                .resizable()
                                                .frame(width: proxy.news.width, height: proxy.news.height)
                                                .aspectRatio(contentMode: .fill)
                                                .cornerRadius(15)
                                                .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                                .padding(5)

                                        }
                                    }.padding(.trailing, 10)
                                    
                                }.buttonStyle(ScaleButtonStyle())
                               
                                
                                .simultaneousGesture(TapGesture().onEnded{
                                    print("news tapped")
                                    let news = object
                                    self.news.news_single = news
                                })
                            }
                            
                        }
                    }
//                    HSTACK END
                    .padding(.leading, 15)
                    .frame(height: 110)
//                    .background(Color.green)
//                    .padding(.top, 15)
                    
                }.frame(height: 110)
//                .background(Color.red)
                
            }
            
        }
        .padding(.bottom, self.news.news.count > 0 ? 10 : 0)
      
    }
}
