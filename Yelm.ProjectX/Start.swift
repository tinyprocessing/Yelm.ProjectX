//
//  ContentView.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import SwiftUI
import Yelm_Server
import Yelm_Chat
import ConfettiView

struct Start: View {
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var notification : notification = GlobalNotification
    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var search : search = GlobalSearch
    @ObservedObject var banner : notification_banner = GlobalNotificationBanner
    
    @ObservedObject var news : news = GlobalNews
    
    
    @State var app_loaded : Bool = false
    
    @State var nav_bar_hide: Bool = true
    @State var items : [items_main_cateroties] = []
    @State private var selection: String? = nil
    
    @State private var isShowingConfetti: Bool = false
    
    
    var body: some View {
        
        let confettiCelebrationView = ConfettiCelebrationView(isShowingConfetti: $isShowingConfetti, timeLimit: 4.0)
        
        ZStack(alignment: .top){
            ZStack{
                if (app_loaded){
                    ZStack(alignment: .bottomLeading){
                        NavigationView{
                            
                            
                            VStack{
                                
                                NavigationLink(destination: Cart().accentColor(Color("BLWH")), tag: "cart", selection: $selection) {
                                    EmptyView()
                                }
                                
                                
                                Home(items: self.$items)
                                
                                
                            }
                            
                            
                            .edgesIgnoringSafeArea(.bottom)
                            .accentColor(Color("BLWH"))
                            .navigationBarTitle("hidden_layer")
                            .navigationBarHidden(self.nav_bar_hide)
                        }
                        
                        if (self.bottom.hide == false){
                            HStack{
                                
                                
                                Spacer()
                                
                                if (true){
                                    
                                    Button(action: {
                                        self.selection = "cart"
                                        
                                    }) {
                                        HStack{
                                            Image(systemName: "cart").font(.system(size: 16, weight: .bold, design: .rounded))
                                            Text("\(String(format:"%.2f", self.realm.price)) \(ServerAPI.settings.symbol)").font(.system(size: 16, weight: .bold, design: .rounded))
                                        }
                                        .padding()
                                        .frame(height: 40)
                                        .background(Color.theme)
                                        .foregroundColor(.theme_foreground)
                                        .cornerRadius(20)
                                        
                                    }.buttonStyle(ScaleButtonStyle())
                                    
                                }
                                
                                
                                
                                
                            }
                            .padding()
                            .padding(.bottom, 20)
                        }
                        
                        
                    }.edgesIgnoringSafeArea(.bottom)
                    ModalAnchorView()
                    
                }
                confettiCelebrationView
            }
            
            if self.banner.show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(self.banner.title)
                                .foregroundColor(.theme_black_change)
                                .bold()
                            Text(self.banner.text)
                                .font(Font.system(size: 16, weight: .medium, design: Font.Design.default))
                                .foregroundColor(.secondary)
                        }.padding()
                        Spacer()
                    }
                    .background(
                        Blur(style: .regular)
                    )
                    .clipShape(CustomShape(corner: .allCorners, radii: 15))
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                    .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                    .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding()
                .offset(y: -5)
                .animation(.linear(duration: 1))
                .transition(AnyTransition.move(edge: .top))
                .transition(.move(edge: .top))
                .onTapGesture {
                    withAnimation(.linear){
                        self.banner.objectWillChange.send()
                        self.banner.show.toggle()
                    }
                }
                .onAppear{
                    self.banner.objectWillChange.send()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation(.linear) {
                            self.banner.show.toggle()
                        }
                    }
                }
            }
        }
        
        
        
        .onAppear{
            self.nav_bar_hide = true
            self.realm.get_total_price()
            
            self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
            self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
            
            let position = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
            ServerAPI.settings.debug = true
            YelmChat.settings.debug = false
            ServerAPI.start(platform: platform, position: position) { (result) in
                if (result == true){
                    
                    
                    
                    ServerAPI.settings.get_settings { (load) in
                        if (load){
                            
                            Color.theme = Color.init(hex: ServerAPI.settings.theme)
                            Color.theme_foreground = Color.init(hex: ServerAPI.settings.foreground)
                            
                            self.app_loaded = true
                            
                        }
                    }
                    let user = UserDefaults.standard.string(forKey: "USER") ?? ""
                    ServerAPI.user.username = user
                    
                  
                    
                    if (user == ""){
                        
                        ServerAPI.user.registration { (load, user) in
                            
                            if (load){
                                UserDefaults.standard.set(user, forKey: "USER")
                                ServerAPI.user.username = user
                                
                                ServerAPI.settings.log(action: "registration")
                                
                                YelmChat.start(platform: platform, user: user) { (load) in
                                    if (load){
                                        YelmChat.core.register { (done) in
                                            if (done){
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        
                        ServerAPI.settings.log(action: "open_load")
                        
                        YelmChat.start(platform: platform, user: user) { (load) in
                            if (load){
                                YelmChat.core.register { (done) in
                                    if (done){
                                        YelmChat.core.server(host: "https://chat.yelm.io/")
                                    }
                                }
                            }
                        }
                    }
                    ServerAPI.items.get_items { (load, items) in
                        if (load){
                            self.items = items
                        }
                    }
                    
                    ServerAPI.items.get_items_all { (load, items) in
                        if (load){
                            
                            self.search.items = items
                        }else{
                            
                        }
                    }
                    
                    ServerAPI.news.get_news { (load, news) in
                        if (load){
                            self.news.news = news
                        }else{
                            
                        }
                    }
                    
                    ServerAPI.items.get_catalog { (load, objects) in
                        if (load){
                            
                        }
                    }
                }
            }
        }
        
    }
}

