//
//  cart.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server

struct Cart: View {
    
    @State var nav_bar_hide: Bool = true
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var cart: cart = GlobalCart
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var cutlery: cutlery = GlobalCutlery
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var payment: payment = GlobalPayment
    
    
    @State var time : String = ""
    @State var price : Float = 0
    
    
    var body: some View {
        
        
        VStack{
            
            
            ZStack(alignment: .bottom){
                VStack {
                    
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
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                            .accessibility(identifier: "exit")
                            
                            Text("Корзина")
                                .padding(.top, 10)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                            
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.realm.clear_cart()
                                
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                                
                            }) {
                                Text("Очистить")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                            
                        }
                        
                        
                        
                    }
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                    .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                    
                    //                if (self.realm.hasSomething) {
                    
                    
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(self.cart.cart_items, id: \.self){ item in
                            CartItem(id: item.id,
                                     title: item.title,
                                     image: item.image,
                                     price: item.price,
                                     price_float: item.price_float,
                                     type: item.type,
                                     quanity: item.quantity)
                                
                                .padding([.trailing, .leading], 20)
                        }
                        
                        
                    
                        
//                        VStack{
//                            HStack(spacing: 10){
//
//                                
//
//                                Image("cutlery")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//
//                                Text("Приборы")
//                                    .fontWeight(.semibold)
//                                    .lineLimit(2)
//                                    .frame(height: 40)
//
//
//                                Spacer()
//
//                                HStack(spacing: 5){
//
//                                    Button(action: {
//
//                                        let generator = UIImpactFeedbackGenerator(style: .soft)
//                                        generator.impactOccurred()
//
//                                        self.cutlery.objectWillChange.send()
//                                        if (self.cutlery.count > 1){
//                                            self.cutlery.count -= 1
//                                        }
//
//                                        print(self.cutlery.count)
//
//                                    }) {
//
//                                        Image(systemName: "minus")
//                                            .foregroundColor(Color.theme_foreground)
//                                            .frame(width: 12, height: 12, alignment: .center)
//                                            .padding([.top, .leading, .bottom, .trailing], 7)
//
//                                            .font(.system(size: 12, weight: .bold, design: .rounded))
//
//                                            .background(Color.theme)
//                                            .clipShape(Circle())
//
//                                    }
//
//                                        .buttonStyle(ScaleButtonStyle())
//
//                                    Text("\(self.cutlery.count)")
//                                        .padding(.horizontal, 4)
//
//                                    Button(action: {
//
//                                        let generator = UIImpactFeedbackGenerator(style: .soft)
//                                        generator.impactOccurred()
//
//                                        self.cutlery.objectWillChange.send()
//                                        if (self.cutlery.count < 5){
//                                            self.cutlery.count += 1
//                                        }
//
//                                        print(self.cutlery.count)
//
//                                    }) {
//
//                                        Image(systemName: "plus")
//                                            .foregroundColor(Color.theme_foreground)
//                                            .frame(width: 12, height: 12, alignment: .center)
//                                            .padding([.top, .leading, .bottom, .trailing], 7)
//
//                                            .font(.system(size: 12, weight: .bold, design: .rounded))
//
//                                            .background(Color.theme)
//                                            .clipShape(Circle())
//
//                                    }
//
//                                        .buttonStyle(ScaleButtonStyle())
//
//
//                                } .padding(.leading, 10)
//
//
//
//                            }.padding([.top, .bottom], 5)
//                            Divider()
//                        }.padding([.trailing, .leading], 20)
//                        .zIndex(-1)
                        
                        VStack{
                            HStack(spacing: 10){
                                
                                Text("Итог ")
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .frame(height: 25)
                                
                                Spacer()
                                
                               
                                
                                Text("\(String(format:"%.2f", self.realm.price)) \(ServerAPI.settings.symbol)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.theme)
                                
                                
                            }.padding([.top, .bottom], 5)
                            Divider()
                        }.padding([.trailing, .leading], 20)
                        
                        
                        if (ServerAPI.settings.shop_id != 0){
                            VStack{
                                HStack(spacing: 0){
                                    
                                    
                                    
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Доставка")
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            
                                            
                                        
                                        //
                                        
                                        if (ServerAPI.settings.order_free_delivery_price > self.realm.price){
                                            
                                            Text("Закажите еще на \(String(format:"%.2f", ServerAPI.settings.order_free_delivery_price - self.realm.price)) \(ServerAPI.settings.symbol) для бесплатной доставки")
                                                .foregroundColor(.secondary)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .lineLimit(2)
                                                .frame(height: 40)
                                            
                                        }
                                        
                                        //
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing){
                                        if (ServerAPI.settings.order_free_delivery_price > self.realm.price){
                                            
                                            Text("\(String(format:"%.2f", self.price)) \(ServerAPI.settings.symbol)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.theme)
                                            
                                        }else{
                                            
                                            Text("0 \(ServerAPI.settings.symbol)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.green)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }.padding([.top, .bottom], 5)
                                Divider()
                            }.padding([.trailing, .leading], 20)
                        }
                        
                        
                        if (ServerAPI.settings.order_minimal_price > self.realm.price){
                            
                            
                            VStack{
                                HStack(spacing: 10){
                                    
                                    
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(Color.orange)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                    
                                    Text("Минимальная сумма заказа - \( String(format:"%.2f", ServerAPI.settings.order_minimal_price)) \(ServerAPI.settings.symbol)")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                        .frame(height: 40)
                                    
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                }.padding([.top, .bottom], 5)
                                Divider()
                            }.padding([.trailing, .leading], 20)
                            
                            
                        }
                        
                        
                        if (ServerAPI.settings.shop_id == 0){
                            
                            
                            VStack{
                                HStack(spacing: 10){
                                    
                                    
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(Color.orange)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                    
                                    Text("Доставка по этому адресу недоступна")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                        .frame(height: 40)
                                    
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                }.padding([.top, .bottom], 5)
                                Divider()
                            }.padding([.trailing, .leading], 20)
                            
                            
                        }
                        
                        if (ServerAPI.settings.deliverly_type == "close"){
                            
                            
                            VStack{
                                HStack(spacing: 10){
                                    
                                    
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(Color.orange)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                    
                                    Text("Время работы: \(ServerAPI.settings.deliverly_time_work)")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                        .frame(height: 40)
                                    
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                }.padding([.top, .bottom], 5)
                                Divider()
                            }.padding([.trailing, .leading], 20)
                            
                            
                        }
                        
                        Spacer(minLength: 150)
                        
                        
                    }
                    
                    
                    Spacer()
                    
                    
                }
                
                VStack(spacing: 0){
                    HStack(spacing: 15){
                        VStack(spacing: 5){
                            Text("\(String(format:"%.2f", self.realm.get_price_full())) \(ServerAPI.settings.symbol)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.theme)
                            
                            HStack{
                                Image(systemName: "clock")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                Text("\(self.time) мин")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        
                        
                        
                        NavigationLink(destination: Offer()) {
                            HStack{
                                Spacer()
                                Text("Оформить")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                            
                        }.buttonStyle(ScaleButtonStyle())
                        .disabled(ServerAPI.settings.position == "lat=0&lon=0" || self.realm.price == 0 || ServerAPI.settings.shop_id == 0 || ServerAPI.settings.order_minimal_price > self.realm.price || self.time == "" || ServerAPI.settings.deliverly_type == "close" ? true : false)
                        .opacity(ServerAPI.settings.position == "lat=0&lon=0" || self.realm.price == 0 || ServerAPI.settings.shop_id == 0 || ServerAPI.settings.order_minimal_price > self.realm.price || self.time == "" || ServerAPI.settings.deliverly_type == "close" ? 0.7 : 1.0)
                        .simultaneousGesture(TapGesture().onEnded{
                            open_offer = true
                            if (ServerAPI.settings.position == "lat=0&lon=0" ){
                                ShowAlert(title: "Адрес", message: "Пожалуйста, выберите адрес для продложения оформления.")
                                open_offer = false
                            }
                            
                            if (ServerAPI.settings.shop_id == 0){
                                ShowAlert(title: "Адрес", message: "Доставка в данном регионе не производится.")
                                open_offer = false
                            }
                            
                        })
                        
                        
                        
                        
                        //                        Кнопка для покупки
                        //                        Данные о сумме заказа
                    }.padding([.trailing, .leading], 20)
                }
                .padding(.bottom, 40)
                .padding(.top, 30)
                .background(.theme_black_change_reverse)
                .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 20))
                //                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropShadow, radius: 15, x: 0, y: 2)
                
            }
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.bottom)
        
        .onAppear {
            self.realm.objectWillChange.send()
            self.bottom.hide = true
            self.nav_bar_hide = true
            
            
            
            ServerAPI.basket.get_basket(items: self.realm.get_ids()) { (load, removable)  in
                if (load){
                    self.time = ServerAPI.settings.deliverly_time
                    self.price = ServerAPI.settings.deliverly_price
                    
                    removable.forEach { (item) in
                        self.realm.set_count(ID: item.item_id, count: item.count)
                    }
                    
                }
            }
            
            if (self.payment.payment_done){
                self.presentation.wrappedValue.dismiss()
            }
            
            
        }
        
        .onDisappear{
            if (open_offer == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }
            
        }
        
        
    }
    
}
