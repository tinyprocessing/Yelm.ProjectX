//
//  subcategories.swift
//  Yelm.ProjectX
//
//  Created by Michael on 19.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Grid


struct Subcategories : View {
    
    @ObservedObject var item: items = GlobalItems
    @ObservedObject var bottom: bottom = GlobalBottom
    @State var nav_bar_hide: Bool = true
    @Environment(\.presentationMode) var presentation
    @ObservedObject var realm: RealmControl = GlobalRealm
    @State var selection: Int? = nil
    
    @State var name : String = ""
    
    
    @State var items : [items_main_cateroties] = []
    
    var body: some View{
        VStack{
            
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
                            
                            .background(Color.blue)
                            .clipShape(Circle())
                        
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                    .buttonStyle(ScaleButtonStyle())
                    
                    Text("\(self.name)")
                        .padding(.top, 10)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                    
                    
                    Spacer()
                }
                
            }
            .padding([.trailing, .leading], 20)
            .padding(.bottom, 10)
            .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
            
            //            Items show grid
            
            ScrollView(showsIndicators: false){
                ForEach(self.items, id: \.self){ object in
                    VStack{
                        HStack(alignment: .center) {
                            Text(object.name)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                            Spacer()
                            
                            
                            NavigationLink(destination: Subcategories(name: object.name), tag: object.id, selection: $selection) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.white)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .padding(7)
                                    
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    
                                    .background(Color.theme)
                                    .clipShape(Circle())
                            }.buttonStyle(ScaleButtonStyle())
                            
                            
                        }.frame(width: UIScreen.main.bounds.width-30)
                        
                        
                        Grid(object.items, id: \.self) { tag in
                            
                            NavigationLink(destination: Item(), tag: 4, selection:  $selection){
                            VStack(alignment: .leading, spacing: 0){
                                
                                HStack{
                                    ZStack(alignment: .top){
                                    URLImage(URL(string: tag.thubnail)!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .frame(width: (UIScreen.main.bounds.width-60)/2, height: (UIScreen.main.bounds.width-60)/2)
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
                                    Spacer()
                                }
                                
                                VStack{
                                Text("\(tag.title) ").font(.system(size: 14, weight: .regular, design: .rounded)) + Text("\(tag.quanity) \(tag.type)").foregroundColor(Color.gray).font(.system(size: 14, weight: .regular, design: .rounded))
                                }.frame(height: 60)
//                                Text(tag.title + " ")
////                                    .frame(height: 60)
//                                    .font(.system(size: 14, weight: .regular, design: .rounded))
//                                    .lineSpacing(2)
//                                    .lineLimit(2)
//                                    .frame(alignment: .leading)
//                                    + Text("100 г").foreground(Color.gray)
                                
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
                                    
//                                    VStack{
//
//                                        if (Float(tag.discount) != tag.price_float){
//
//                                            Text("\(String(format:"%.2f", tag.price_float)) ₽")
//                                                .strikethrough()
//                                                .lineLimit(1)
//                                                .foregroundColor(.gray)
//                                                .font(.system(size: 12, weight: .medium, design: .rounded))
//                                        }
//
//
//
//                                        Text("\(tag.quanity) \(tag.type)")
//                                            .lineLimit(1)
//                                            .foregroundColor(.gray)
//                                            .font(.system(size: 12, weight: .medium, design: .rounded))
//                                    }
                                    
                                    
                                    
                                }
                                
                                Spacer()
                                
                            }
                                .frame(height: 245)
                                .padding(.top, 15)
                                .padding(.bottom, 30)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded{
                                open_item = true
                                let item = tag
                                self.item.item = item
                            })
                            
                            
                        }.gridStyle(
                            //.frame(width: 180, height: 245)
                            ModularGridStyle(columns: 2, rows: .fixed(265))
                        )
                    }
                    
                }
                
            }.frame(width: UIScreen.main.bounds.size.width-30)
            
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
            
            ServerAPI.items.get_items { (load, items) in
                if (load){
                    
                    self.items = items
                }
            }
        }
        
        .onDisappear{
            if (open_item == false){
                self.bottom.hide = false
            }
        }
        
    }
}
