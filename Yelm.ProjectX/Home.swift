//
//  Home.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Yelm_Chat


struct Home: View {
    
    @ObservedObject var chat : ChatIO = YelmChat
    
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var categories : categories = GlobalCategories
    @ObservedObject var search : search = GlobalSearch
    @ObservedObject var badge : chat_badge = GlobalBadge


    
    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var modal : ModalManager = GlobalModular
    @ObservedObject var loading: loading = GlobalLoading
    @Binding var items : [items_main_cateroties]
    @State var selection: String? = nil
    
    
    @State var time = Timer.publish(every: 2, on: .current, in: .common).autoconnect()

    
    @State var selection_open: String? = nil
    
    @State private var isAnimating = false
    
    @ObservedObject var payment: payment = GlobalPayment
    @ObservedObject var notification_open : notification_open = GlobalNotificationOpen

    @ObservedObject var news : news = GlobalNews
    
    
    func width(y: CGFloat) -> CGFloat {
        let screen = CGFloat(UIScreen.main.bounds.width-90)
        let header: CGFloat = 47
        let width = (screen)-pow(((y-header)*0.01+1.2), 6.995)
        
        if (width <= 40){
            if (self.loading.loading == false){
                self.loading.objectWillChange.send()
                self.loading.loading = true
                
                
                ServerAPI.news.get_news { (load, news) in
                    if (load){
                        self.news.news = news
                    }else{
                        
                    }
                }
                
                ServerAPI.items.get_items { (ready, items) in
                    
                    if (ready){
                        
                        self.items = items
                        
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                            withAnimation{
                                self.loading.loading = false
                            }
                        }
                    }
                    
                }
                
                ServerAPI.items.get_catalog { (load, objects) in
                    if (load){
                        self.categories.all = objects
                    }
                }
                
                
                ServerAPI.items.get_items_all { (load, items) in
                    if (load){
                        
                        self.search.items = items
                    }else{
                        
                    }
                }
            }
            return 40.0
        }
        
        return width
    }
    
    
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 0){
                
                VStack{
                    Color.white
                }.frame(width: UIScreen.main.bounds.width, height: 0)
                .offset(y: -5)
                
                
                    
                    
                    
                    GeometryReader{ geo -> AnyView in
                        
                        
                        return AnyView(
                            
                            HStack{
                                
                                NavigationLink(destination: Search().accentColor(Color("BLWH")), tag: "search", selection: $selection) {
                                    HStack{
                                        Image(systemName: "magnifyingglass").font(.system(size: 18, weight: .medium, design: .rounded))
                                    }
                                }.buttonStyle(ScaleButtonStyle())
                                
                                Spacer()
                                
                                
                                Button(action: {
//                                    Open modal with locations
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                                        self.modal.newModal(position: .closed) {
                                            ModalLocation()
                                                .clipped()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            self.modal.openModal()
                                        }
                                    }
                                    
                                }) {
                                    
                                    
                                    
                                    VStack(alignment: .center){
                                        
                                        if (self.loading.loading){
                                            
                                            
                                            Image(systemName: "arrow.2.circlepath")
                                                .foregroundColor(.theme_foreground)
                                                .transition(.opacity)
                                                
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                                                .animation(self.isAnimating ? forever : .default)
                                                .onAppear { self.isAnimating = true }
                                                .onDisappear { self.isAnimating = false }
                                            
                                            
                                            
                                            
                                        }else{
                                            ZStack(alignment: .center){
                                                Text(" \(self.location.name) ")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(.theme_foreground)
                                                    .lineLimit(1)
                                                    .opacity(Double((width(y: geo.frame(in: .global).minY)-110) * 0.01))
                                                
                                                if (Double((width(y: geo.frame(in: .global).minY)-110) * 0.01) < 0.6){
                                                    Image(systemName: "arrow.2.circlepath")
                                                        .foregroundColor(.theme_foreground)
                                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                                        .transition(.opacity)
                                                        
                                                        .opacity(1.0-Double((width(y: geo.frame(in: .global).minY)-110) * 0.01))
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                    .frame(width: self.loading.loading == false ? (geo.frame(in: .global).minY <= 43.5 ? UIScreen.main.bounds.width-90 : width(y: geo.frame(in: .global).minY)) : 40)
                                    .frame(height: 40)
                                    .transition(.slide)
                                    .background(Color.theme)
                                    .cornerRadius(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            
                                            .fill(Color.neuBackground)
                                            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                        
                                    )
                                    
                                }.buttonStyle(ScaleButtonStyle())
                                Spacer()
                                
                        
                                    ZStack(alignment: .topTrailing){
                                        NavigationLink(destination: Chat(), tag: "chat", selection: $selection) {
                                            ZStack(alignment: .top){
                                                HStack{
                                                    ZStack{
                                                    Image(systemName: "bubble.left").font(.system(size: 18, weight: .medium, design: .rounded))

                                                    }
                                                }

                                                
                                            }
                                        }.buttonStyle(ScaleButtonStyle())
                                       
                                        if (self.badge.count > 0){
                                            ZStack{
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 15, height: 15)
                                                Text("!")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.white)
                                            }.offset(x: 5, y: -10)
                                        }

                                    }
                                   
                                
                                
                            }.frame(width: UIScreen.main.bounds.width-30)
                            
                            
                        
                            
                        )
                        
                    }
                    .frame(width: UIScreen.main.bounds.width-30)
                    .frame(height: 50)
                    .zIndex(1)
                    
                
                ScrollView(.vertical, showsIndicators: false){




                    News()

                    Feed()
                    
                    ForEach(self.items, id: \.self) { object in
                        ItemsViewLine(items: object.items, category_id: object.id, name: object.name)
                    }

                    catalog()

                    Spacer(minLength: 100)
                }.zIndex(0)
                    
                    
                
                
                NavigationLink(destination: Item(), tag: "open_item", selection: $selection_open) {
                  
               }
                NavigationLink(destination: NewsSingle(), tag: "open_news", selection: $selection_open) {
                  
               }
                
                NavigationLink(destination: Chat(), tag: "chat", selection: $selection_open) {
                  
               }
                
            }
            .onReceive(self.time, perform: { (_) in
                
                
                if (self.notification_open.key == "chat"){
                    self.notification_open.key = ""
                    
                    YelmChat.core.get()
                    
                    self.selection_open = "open_chat"
                    ServerAPI.settings.log(action: "open_chat_notification", about: "")
                  
                    
                }
                
                
                if (self.notification_open.key == "news"){
                    self.notification_open.key = ""
                    
                    
                    ServerAPI.news.get_news_id(id: self.notification_open.value) { (load, object) in
                        self.selection_open = "open_news"
                        ServerAPI.settings.log(action: "open_news_notification", about: "\(object.id)")
                        self.news.news_single = object
                    }
                    
                }
                
                if (self.notification_open.key == "item"){
                    self.notification_open.key = ""
                    
                    ServerAPI.items.get_item(id: self.notification_open.value) { (load, object) in
                        self.selection_open = "open_item"
                        ServerAPI.settings.log(action: "open_item_notification", about: "\(object.id)")
                        self.item.item = object
                    }
                    
                }
                
            })
          
            
            
            
        }
        .onAppear{
            
            open_offer = false
            
           
           
            // check payments
            if(self.payment.payment_done){
                self.payment.payment_done = false
                
                
               //payment_free
                if (self.payment.payment_free){
                    self.payment.payment_free = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        ShowAlert(title: "Отлично", message: "Детали Вашего заказа отправлены в чат.")
                        
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        ShowAlert(title: "Отлично", message: "Оплата прошла успешно - детали Вашего заказа отправлены в чат.")
                        
                    }
                }

            }
        }
    }
}
