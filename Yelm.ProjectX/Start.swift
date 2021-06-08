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
    @ObservedObject var categories : categories = GlobalCategories
    @ObservedObject var banner : notification_banner = GlobalNotificationBanner
    @ObservedObject var user: user_auth = GlobalUserAuth

    @ObservedObject var news : news = GlobalNews
    @ObservedObject var modal : ModalManager = GlobalModular

    
    @State var app_loaded : Bool = false
    @State var settings_loaded : Bool = false
    
    @State var nav_bar_hide: Bool = true
    @State var items : [items_main_cateroties] = []
    @State private var selection: String? = nil
    
    @State private var isShowingConfetti: Bool = false
    @ObservedObject var image_view: image_view = GlobalImageView

    
    var body: some View {
        
        let confettiCelebrationView = ConfettiCelebrationView(isShowingConfetti: $isShowingConfetti, timeLimit: 4.0)
        
        ZStack(alignment: .top){
            ZStack{
                
                if (self.settings_loaded){
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
                        }.navigationViewStyle(StackNavigationViewStyle())
                        
                        if (self.bottom.hide == false){
                            HStack{
                                
                                if (platform != "yelmio" && distribution == false){
                                    HStack{
                                    Button(action: {
                                        platform = "yelmio"
                                        self.realm.clear_cart()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            windows?.rootViewController =  UIHostingController(rootView: Start())
                                        }
                                        
                                    }) {
                                        HStack{
                                            Image(systemName: "xmark")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                        }
                                        .padding()
                                        .frame(width: 40, height: 40)
                                        .background(Color.theme)
                                        .foregroundColor(.theme_foreground)
                                        .cornerRadius(20)
                                        
                                    }.buttonStyle(ScaleButtonStyle())
                                    }
                                  
                                    
                                }
                                
                                if (platform != "yelmio" && distribution == false){
                                    HStack{
                                    Button(action: {
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            windows?.rootViewController =  UIHostingController(rootView: Start())
                                        }
                                        
                                    }) {
                                        HStack{
                                            Image(systemName: "arrow.clockwise")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                        }
                                        .padding()
                                        .frame(width: 40, height: 40)
                                        .background(Color.theme)
                                        .foregroundColor(.theme_foreground)
                                        .cornerRadius(20)
                                        
                                    }.buttonStyle(ScaleButtonStyle())
                                    }
                                  
                                    
                                }
                                
                                
                                Spacer()
                                
                                if (true){
                                    HStack{
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
                                
                                
                                
                                
                            }
                           
                            .padding()
                            .padding(.bottom, 20)
                          
                        }
                        
                        
                    }.edgesIgnoringSafeArea(.bottom)
                    .opacity(app_loaded ? 1.0 : 0)
                }
                    ModalAnchorView()
                    
                
                    LoaderEnot()
                        .opacity(app_loaded ? 0 : 1.0)
                
                confettiCelebrationView
            }
            
            if self.banner.show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
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
                        Blur(style: .prominent)
                    )
                    .clipShape(CustomShape(corner: .allCorners, radii: 15))
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
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(ImageViewerRemote(imageURL: self.$image_view.image, viewerShown: self.$image_view.show))
        .preferredColorScheme(platform == "yelmio" ? .light : .none)
        
        
        .onAppear{
            self.nav_bar_hide = true
            self.realm.get_total_price()
            
            self.location.name = UserDefaults.standard.string(forKey: "SELECTED_SHOP_NAME") ?? "Выберите адрес"
            self.location.point = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
            
            let position = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
            ServerAPI.settings.debug = false
            YelmChat.settings.debug = false
            

            self.user.objectWillChange.send()
//            self.user.auth = true
            self.user.auth = UserDefaults.standard.bool(forKey: "auth") ?? false
            self.user.balance = UserDefaults.standard.integer(forKey: "balance") ?? 0
            self.user.name = UserDefaults.standard.string(forKey: "name") ?? ""
         
            
            ServerAPI.start(platform: platform, position: position) { (result) in
                if (result == true){
                    
                    
                    
                    DispatchQueue.main.async {
                        ServerAPI.settings.get_settings { (load) in
                        if (load){
                            
                            
                            ServerAPI.objectWillChange.send()
                            
                            Color.theme = Color.init(hex: ServerAPI.settings.theme)
                            Color.theme_foreground = Color.init(hex: ServerAPI.settings.foreground)
                            
                            Color.theme_catalog = Color.init(hex: ServerAPI.settings.theme_catalog)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.settings_loaded = true
                            }
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
                                withAnimation(.easeInOut(duration: 0.5), {
                                    self.app_loaded = true
                                 })
                                
                                let region = UserDefaults.standard.integer(forKey: "rating")
                                
//                                if (region == 0){
//
//                                    self.modal.newModal(position: .closed) {
//                                        ModalLocation()
//                                            .clipped()
//                                    }
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
//                                        self.modal.openModal()
//                                    }
//
//                                }
                                
                                AppStoreReviewManager.requestReviewIfAppropriate()
                                
                            }
                            
                            
                        }
                    }
                    }
//                    user controlls
                    let user = UserDefaults.standard.string(forKey: "USER") ?? ""
                    ServerAPI.user.username = user
                    
                  
                    
                    
                    DispatchQueue.main.async {
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
                               
                                if (self.user.auth){
                                ServerAPI.user.account_get_information(){ load, json in

                                    self.user.balance = json["user"]["info"]["balance"].int!
                                    self.user.name = json["user"]["info"]["name"].string!

                                    self.user.notifications = json["user"]["notification"].bool!

                                    UserDefaults.standard.set(json["user"]["info"]["balance"].int!, forKey: "balance")
                                    UserDefaults.standard.set(json["user"]["info"]["name"].string!, forKey: "name")

                                    }
                                }
                            }
                        }
                    }else{
                        
                    
                        if (self.user.auth){
                            ServerAPI.user.account_get_information(){ load, json in
                            
                                print(json)
                            self.user.balance = json["user"]["info"]["balance"].int!
                            self.user.name = json["user"]["info"]["name"].string!
                             
                            self.user.notifications = json["user"]["notification"].bool!
                                
                            UserDefaults.standard.set(json["user"]["info"]["balance"].int!, forKey: "balance")
                            UserDefaults.standard.set(json["user"]["info"]["name"].string!, forKey: "name")
                            
                            }
                        }
                        
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
                    }
                    
                    DispatchQueue.main.async {
                        ServerAPI.items.get_items { (load, items) in
                            if (load){
                                DispatchQueue.main.async {
                                 self.items = items
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        ServerAPI.items.get_items_all { (load, items) in
                            if (load){

                                DispatchQueue.main.async {
                                    self.search.items = items
                                }
                            }else{
                                
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        ServerAPI.news.get_news { (load, news) in
                            if (load){
                                DispatchQueue.main.async {
                                    self.news.news = news
                                }
                            }else{
                                
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        ServerAPI.items.get_catalog { (load, objects) in
                            if (load){
                                DispatchQueue.main.async {
                                    self.categories.all = objects
                                }
                            }
                        }
                    }
                    
                }
            }
            
            region_change()
            
          
        }
        
    }
}

