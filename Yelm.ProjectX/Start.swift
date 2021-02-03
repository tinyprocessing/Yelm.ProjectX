//
//  ContentView.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import SwiftUI
import Yelm_Server
import Yelm_Chat


struct Start: View {
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var notification : notification = GlobalNotification
    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var search : search = GlobalSearch

    @ObservedObject var news : news = GlobalNews

    
    @State var app_loaded : Bool = false
    
    @State var nav_bar_hide: Bool = true
    @State var items : [items_main_cateroties] = []
    @State private var selection: String? = nil

    var body: some View {
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
                
            }else{
                
            }
            
        }
            
      
        
            .onAppear{
                self.nav_bar_hide = true
                self.realm.get_total_price()
                
                self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
                self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
                
                let position = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
                ServerAPI.settings.debug = true
                ServerAPI.start(platform: "5fd33466e17963.29052139", position: position) { (result) in
                    if (result == true){
                        
                        
                        
                        ServerAPI.settings.get_settings { (load) in
                            if (load){
                                
                                Color.theme = Color.init(hex: ServerAPI.settings.theme)
                                Color.theme_foreground = Color.init(hex: ServerAPI.settings.foreground)
                                
                                self.app_loaded = true
                                
                            }
                        }
                        let user = UserDefaults.standard.string(forKey: "USER") ?? ""
                        
                        if (user == ""){
                            ServerAPI.user.registration { (load, user) in
                                if (load){
                                    UserDefaults.standard.set(user, forKey: "USER")
                                    YelmChat.start(platform: "5fd33466e17963.29052139", user: user) { (load) in
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
                            YelmChat.start(platform: "5fd33466e17963.29052139", user: user) { (load) in
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
                    }
                }
            }
        
    }
}

