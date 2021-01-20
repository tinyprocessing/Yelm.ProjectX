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
//                                                .background(Color.red)
                                            
                                            
                                        }
                                        
                                        
                                        HStack {
                                            
                                            
                                            Text("Товары: ")
                                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                            
                                            
                                            Spacer()
                                            
                                            
                                            
                                        }
                                        .padding(.horizontal, 20)
                                     
                                        
                                        
                                        ScrollView(.horizontal, showsIndicators: false){
                                            
                                            HStack{
                                                
                                                ForEach(self.items, id: \.self) { tag in
                                                    
                                                    VStack{
                                                        NavigationLink(destination: Item(), tag: 4, selection:  $selection){
                                                        
                                                        VStack(alignment: .leading, spacing: 0){
                                                            
                                                            ZStack(alignment: .top){
                                                                URLImage(URL(string: tag.thubnail)!) { proxy in
                                                                    proxy.image
                                                                        .resizable()
                                                                        .frame(width: 180, height: 180)
                                                                        .cornerRadius(20)
                                                                }
                                                                .overlay(
                                                                    Rectangle()
                                                                        .fill(Color.black)
                                                                        .cornerRadius(20)
                                                                        .opacity( self.realm.get_item_access(ID: tag.id) ? 0.3 : 0)
                                                                        .overlay(
                                                                            
                                                                            VStack{
                                                                                if (self.realm.get_item_access(ID: tag.id)){
                                                                                    Text(String(self.realm.get_items_count(ID: tag.id)))
                                                                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                                                                        .foregroundColor(.white)
                                                                                        .frame(width: 100, height: 50)
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                        )
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                )
                                                                HStack(spacing: 0){
                                                                    
                                                                    Spacer()
                                                                    
                                                                    HStack{
                                                                        
                                                                        if (tag.action.contains("1+1")){
                                                                            VStack{
                                                                                Text("1+1")
                                                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                                                    .padding(5)
                                                                                    .padding(.horizontal, 10)
                                                                                    .foregroundColor(.white)
                                                                            }
                                                                            .background(Color.orange)
                                                                            .cornerRadius(20)
                                                                            .padding(.top, 7)
                                                                            .padding(.trailing, 5)
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                    HStack{
                                                                        
                                                                        if (tag.discount_present != "-0%"){
                                                                            
                                                                            VStack{
                                                                                Text("\(tag.discount_present)")
                                                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                                                    .padding(5)
                                                                                    .padding(.horizontal, 10)
                                                                                    .foregroundColor(.white)
                                                                            }
                                                                            .background(Color.green)
                                                                            .cornerRadius(20)
                                                                            .padding(.top, 7)
                                                                            .padding(.trailing, 7)
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                            
                                                            Text(tag.title)
                                                                .frame(height: 50)
                                                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                                                .lineSpacing(2)
                                                                .lineLimit(2)
                                                                .frame(alignment: .leading)
                                                            
                                                            HStack{
                                                                
                                                                HStack(spacing: 0){
                                                                    
                                                                    if (self.realm.get_item_access(ID: tag.id)){
                                                                        
                                                                        
                                                                        Button(action: {
                                                                            
                                                                            
                                                                            self.realm.post_cart(ID: tag.id, method: "decrement")
                                                                            
                                                                            
                                                                        }) {
                                                                            
                                                                            Rectangle()
                                                                                .fill(Color.theme)
                                                                                .frame(width: 16, height: 30)
                                                                                .overlay(
                                                                                    Image(systemName: "minus")
                                                                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                                        .foregroundColor(.white)
                                                                                )
                                                                            
                                                                            
                                                                            
                                                                            
                                                                        }
                                                                        
                                                                        .padding(.leading, 8)
                                                                        .padding(.trailing, 5)
                                                                        .buttonStyle(PlainButtonStyle())
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    Text("\(tag.discount) ₽")
                                                                        .lineLimit(1)
                                                                        .foregroundColor(.white)
                                                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                        .padding([.top, .bottom], 7)
                                                                        .background(Color.theme)
                                                                        .cornerRadius(20)
                                                                        .fixedSize()
                                                                        .padding(.leading, self.realm.get_item_access(ID: tag.id) ? 0 : 12)
                                                                    
                                                                    
                                                                    Button(action: {
                                                                        
                                                                        
                                                                        
                                                                        if (self.realm.get_item_access(ID: tag.id) == false) {
                                                                            
                                                                            
                                                                            self.realm.objectWillChange.send()
                                                                            self.realm.create_item_cart(ID: tag.id, Title: tag.title, Price: tag.price_float, PriceItem: tag.price_float, Count: 1, Thumbnail: tag.thubnail, ItemType: tag.type, Quantity: tag.quanity, CanIncrement: "1", Discount: tag.discount_value)
                                                                            
                                                                            
                                                                            self.realm.objectWillChange.send()
                                                                            
                                                                            
                                                                            let generator = UIImpactFeedbackGenerator(style: .soft)
                                                                            generator.impactOccurred()
                                                                        }else{
                                                                            self.realm.post_cart(ID: tag.id, method: "increment")
                                                                        }
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    }) {
                                                                        
                                                                        Rectangle()
                                                                            .fill(Color.theme)
                                                                            .frame(width: 16, height: 30)
                                                                            .overlay(
                                                                                Image(systemName: "plus")
                                                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                                    .foregroundColor(.white)
                                                                            )
                                                                        
                                                                    }
                                                                    .padding(.trailing, 8)
                                                                    .padding(.leading, 5)
                                                                    .buttonStyle(PlainButtonStyle())
                                                                    
                                                                }
                                                                .background(Color.theme)
                                                                .cornerRadius(20)
                                                                
                                                                Spacer()
                                                                
                                                                VStack{
                                                                    
                                                                    if (Float(tag.discount) != tag.price_float){
                                                                        
                                                                        Text("\(String(format:"%.2f", tag.price_float)) ₽")
                                                                            .strikethrough()
                                                                            .lineLimit(1)
                                                                            .foregroundColor(.gray)
                                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    Text("\(tag.quanity) \(tag.type)")
                                                                        .lineLimit(1)
                                                                        .foregroundColor(.gray)
                                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                                }
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                        }
                                                        
                                                        .frame(width: 180, height: 245)
                                                        
                                                        .padding(.leading, 20)
                                                        .padding(.top, 15)
                                                        .padding(.bottom, 30)
                                                        
                                                    }.buttonStyle(ScaleButtonStyle())
                                                    }.background(Color.white)

                                                                        
                                                    .simultaneousGesture(TapGesture().onEnded{
                                                        let item = tag
                                                        self.item.item = item
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                                Spacer()
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        
                                        Spacer(minLength: self.news.news_single.description.count > 1 ? 120 : UIScreen.main.bounds.height)
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.white)
                            .cornerRadius(40)
//                            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 40))
                            
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
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}


