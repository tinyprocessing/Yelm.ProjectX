//
//  ItemV4View.swift
//  Yelm Media Engine
//
//  Created by Michael on 16.12.2020.
//

import SwiftUI
import Yelm_Server


/// Для товаров на главной
struct ItemsViewLine: View {
    
    @ObservedObject var item: items = GlobalItems
    @State var items : [items_structure] = []
    @State var category_id : Int = 0
    @State var name : String = ""
    @State var selection: String? = nil
    @ObservedObject var realm: RealmControl = GlobalRealm
    @State var search : String = ""
    
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack(alignment: .center) {
                Text(self.name)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                Spacer()
                
                
                
                NavigationLink(destination: Subcategories(category_id: self.category_id, name: self.name), tag: "subcatalog", selection: $selection) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme_foreground)
                        .frame(width: 15, height: 15, alignment: .center)
                        .padding(7)
                        
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        
                        .background(Color.theme)
                        .clipShape(Circle())
                }.buttonStyle(ScaleButtonStyle())
                
                
            }.frame(width: UIScreen.main.bounds.width-30)
            .padding(.bottom)
            
            if (self.items.count > 3){
                SubcategoriesGrid(items: self.items, search: $search)
                    .frame(width: UIScreen.main.bounds.size.width-30)
            }else{
                LineItems(items: self.items)
                
            }
        }
    }
}



struct LineItems : View{
    
    @ObservedObject var item: items = GlobalItems
    @State var items : [items_structure] = []
    @ObservedObject var realm: RealmControl = GlobalRealm
    @State var selection: String? = nil
    @State var category_id : Int = 0
    @State var name : String = ""
    
    
    var body : some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack{
                
                
                ForEach(self.items, id: \.self) { tag in
                    
                    
                    VStack{
                        NavigationLink(destination: Item(), tag: "item\(tag.id)", selection: $selection){
                            
                            
                            VStack(alignment: .leading, spacing: 0){
                                
                                ZStack(alignment: .top){
                                    URLImage(URL(string: tag.thubnail)!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
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
                                                            .foregroundColor(.theme_foreground)
                                                    )
                                                
                                                
                                                
                                                
                                            }
                                            
                                            .padding(.leading, 8)
                                            .padding(.trailing, 5)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                        }
                                        
                                        if (floor((tag.discount as NSString).floatValue) == (tag.discount as NSString).floatValue){
                                            
                                            Text("\(String(format:"%.0f", (tag.discount as NSString).floatValue) ) \(ServerAPI.settings.symbol)")
                                                .lineLimit(1)
                                                .foregroundColor(.theme_foreground)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .padding([.top, .bottom], 7)
                                                .background(Color.theme)
                                                .cornerRadius(20)
                                                .fixedSize()
                                                .padding(.leading, self.realm.get_item_access(ID: tag.id) ? 0 : 12)
                                            
                                        }else{
                                            
                                            Text("\(tag.discount) \(ServerAPI.settings.symbol)")
                                                .lineLimit(1)
                                                .foregroundColor(.theme_foreground)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .padding([.top, .bottom], 7)
                                                .background(Color.theme)
                                                .cornerRadius(20)
                                                .fixedSize()
                                                .padding(.leading, self.realm.get_item_access(ID: tag.id) ? 0 : 12)
                                        }
                                        
                                        
                                        Button(action: {
                                            
                                            
                                            
                                            if (self.realm.get_item_access(ID: tag.id) == false) {
                                                
                                                
                                                logAddToCartEvent(contentData: tag.title,
                                                                  contentId: String(tag.id),
                                                                  contentType: "item",
                                                                  currency: ServerAPI.settings.currency,
                                                                  price: Double(tag.price_float))
                                                
                                                self.realm.objectWillChange.send()
                                                self.realm.create_item_cart(ID: tag.id, Title: tag.title, Price: tag.price_float, PriceItem: tag.price_float, Count: 1, Thumbnail: tag.thubnail, ItemType: tag.type, Quantity: tag.quanity, CanIncrement: "1", Discount: tag.discount_value)
                                                
                                                
                                                self.realm.objectWillChange.send()
                                                
                                                
                                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                                generator.impactOccurred()
                                            }else{
                                                self.realm.post_cart(ID: tag.id, method: "increment")
                                                
                                                logAddToCartEvent(contentData: tag.title,
                                                                  contentId: String(tag.id),
                                                                  contentType: "item",
                                                                  currency: ServerAPI.settings.currency,
                                                                  price: Double(tag.price_float))
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }) {
                                            
                                            Rectangle()
                                                .fill(Color.theme)
                                                .frame(width: 16, height: 30)
                                                .overlay(
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                                        .foregroundColor(.theme_foreground)
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
                                            
                                            if (floor(tag.price_float) == tag.price_float){
                                                
                                                Text("\(String(format:"%.0f", tag.price_float)) \(ServerAPI.settings.symbol)")
                                                    .strikethrough()
                                                    .lineLimit(1)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                            }else{
                                                
                                                Text("\(String(format:"%.2f", tag.price_float)) \(ServerAPI.settings.symbol)")
                                                    .strikethrough()
                                                    .lineLimit(1)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                
                                            }
                                            
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
                            
                            .padding(.leading, 15)
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                            
                        }.buttonStyle(ScaleButtonStyle())
                    }
                    
                    
                    .simultaneousGesture(TapGesture().onEnded{
                        ServerAPI.settings.log(action: "open_item", about: "\(tag.id)")
                        let item = tag
                        self.item.item = item
                    })
                    
                    
                    
                    
                    
                }
                
                
                
                
                Spacer()
                
                
            }
            
        }
        
    }
}
