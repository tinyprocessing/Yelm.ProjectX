//
//  news_single.swift
//  Yelm.ProjectX
//
//  Created by Michael on 18.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server

struct NewsSingle : View {
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var news: news = GlobalNews
    @State var nav_bar_hide: Bool = true
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    
    @ObservedObject var status: loading_webview = GlobalWebview
    @ObservedObject var realm: RealmControl = GlobalRealm
    
    
    
    
    @State var color = 0
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @Environment(\.presentationMode) var presentation
    
    @State var show : Float = 0.0
    
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var opacity : Double = 0
    
    var body: some View{
        
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            // First Parallax Scroll...
                            
                            GeometryReader{reader in
                                
                                VStack{
                                    
                                    
                                    URLImage(URL(string: self.news.news_single.images)!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            // default widht...
                                            .frame(width: UIScreen.main.bounds.width+20, height: reader.frame(in: .global).minY > 0 ? CGFloat(Int(reader.frame(in: .global).minY + 245)) : 245)
                                            // adjusting view postion when scrolls...
                                            .offset(y: -reader.frame(in: .global).minY)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            // setting default height...
                            .frame(height: 200)
                            
                            // List Of Songs...
                            
                            VStack(spacing: 5){
                                
                                
                                if (self.news.news_single.title.count > 0){
                                    
                                    GeometryReader{g in
                                        VStack{
                                            Text("")
                                        }
                                        .onReceive(self.time) { (_) in
                                            
                                            
                                            if (g.frame(in: .global).minY < 80){
                                                withAnimation{
                                                    self.show = 1.0
                                                }
                                            }else{
                                                withAnimation{
                                                    self.show = 0.0
                                                }
                                            }
                                        }
                                    } .frame(height: 0)
                                    
                                    HStack {
                                        
                                        
                                        Text(self.news.news_single.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                        
                                        
                                        Spacer()
                                        
                                        
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                    
                                }
                                
                                
                                ZStack(alignment: .top){
                                    VStack(alignment: .leading){
                                        
                                        if (self.news.news_single.description.count > 1){
                                            
                                            
                                            HTMLStringView(htmlContent: self.news.news_single.description)
                                                .frame(height: self.status.height+(UIScreen.main.bounds.height-self.status.height))
                                                .padding(.horizontal, 16)
                                                .padding(.top, 5)
                                            
//                                            Text(self.news.news_single.description)
//                                                .foregroundColor(Color.secondary)
//                                                .font(.system(size: 16, weight: .medium, design: .rounded))
//                                                .padding(.horizontal, 20)
//                                                .padding(.top, 5)
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                        Spacer(minLength: self.news.news_single.description.count > 1 ? 120 : UIScreen.main.bounds.height)
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.white)
                            
                            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 40))
                            
                        } .background(Color.white)
                    }
                    
                }
                
                VStack{
                    
                    HStack(alignment: .center){
                        Button(action: {
                            
                            self.presentation.wrappedValue.dismiss()
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                        }) {
                            
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)
                                
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                
                                .background(Color.theme)
                                .clipShape(Circle())
                            
                        }
                        .padding(.top, 10)
                        .buttonStyle(ScaleButtonStyle())
                        
                        
                        
                        Spacer()
                        
                        if (self.show == 1.0){
                            Text(self.news.news_single.title)
                                .padding(.top, 10)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                        }
                        
                        
                        
                        
                        Spacer()
                        
                        
                        Button(action: {
                            
                            
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                        }) {
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)
                                
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                
                                .background(Color.theme)
                                .clipShape(Circle())
                            
                        }
                        .padding(.top, 10)
                        
                        .buttonStyle(ScaleButtonStyle())
                        
                        
                        
                    }
                    .padding(.top, (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .background(self.show == 1.0 ? Color.white : Color.clear)
                }
                
            }
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onAppear {
            self.bottom.hide = true
            self.nav_bar_hide = true
        }
        
        .onDisappear{
            
            if (open_item == false){
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}


