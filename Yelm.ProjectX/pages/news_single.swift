//
//  news_single.swift
//  Yelm.ProjectX
//
//  Created by Michael on 18.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Grid




struct NewsSingle : View {
    
    
    @State var nav_bar_hide: Bool = true
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var items : [items_structure] = []
    @State var selection: Int? = nil
    @State var color = 0
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @State var show : Float = 0.0
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var news: news = GlobalNews
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var status: loading_webview = GlobalWebview
    @ObservedObject var realm: RealmControl = GlobalRealm
    
    @Environment(\.presentationMode) var presentation
    
    
    
    
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
                                                .frame(height: self.status.height)
                                                .padding(.horizontal, 16)
                                                .padding(.top, 5)
//                                                .background(Color.theme_black_change_reverse)
                                            
                                            
                                        }
                                        
                                        if (self.items.count > 0){
                                            HStack {
                                                
                                                
                                                Text("Товары: ")
                                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                                
                                                
                                                Spacer()
                                                
                                                
                                                
                                            }
                                            .padding(.horizontal, 20)
                                            
                                            
                                            ItemsInNews(items: self.items)
                                        }
                                        
                                        
                                        
                                       
                                        
                                        
                                        
                                        Spacer(minLength: self.news.news_single.description.count > 1 ? 120 : UIScreen.main.bounds.height)
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.theme_black_change_reverse)
                            .cornerRadius(40)
                            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 40))
                            
                        } .background(Color.theme_black_change_reverse)
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
                                .foregroundColor(Color.theme_foreground)
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
                            
                            
                            ServerAPI.settings.log(action: "share_news", about: "\(self.news.news_single.id)")
                            
                            guard let data = URL(string: "https://yelm.io/news/\(self.news.news_single.id)") else { return }
                                  let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                                  UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                            
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                        }) {
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color.theme_foreground)
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
                    .padding(.top, notch ? 0 : 20)
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .background(self.show == 1.0 ? Color.theme_black_change_reverse : Color.clear)
                }
                
            }
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onAppear {
            self.status.height = 0
            
            self.bottom.hide = true
            self.nav_bar_hide = true
            print("id: \(self.news.news_single.id)")
            ServerAPI.news.get_news_items(id: self.news.news_single.id) { (load, items) in
                if (load){
                    self.items = items
                    print(items)
                }
            }
        }
        
        .onDisappear{
            
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}


