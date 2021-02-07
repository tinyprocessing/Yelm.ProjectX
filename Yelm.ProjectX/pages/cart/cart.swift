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

                        if (ServerAPI.settings.shop_id != 0){
                            VStack{
                                HStack(spacing: 0){
                                    
                                    
                                    
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Доставка")
                                            .lineLimit(2)
                                            
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        
    //
    //                                    Text("Закажите еще на 300 рублей для бесплатной доставки")
    //                                        .foregroundColor(.secondary)
    //                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
    //                                        .lineLimit(2)
    //                                        .frame(height: 40)
                                        
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing){
                                        Text("\(String(format:"%.2f", self.price)) \(ServerAPI.settings.symbol)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.theme)
                                        
                                    } .padding(.horizontal, 10)
                                    
                                    
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
                        
                        Spacer(minLength: 150)
                        
                        
                    }
                    
                    
                    Spacer()
                    
                    
                }
                
                VStack(spacing: 0){
                    HStack(spacing: 15){
                        VStack(spacing: 5){
                            Text("\(String(format:"%.2f", self.realm.price + ServerAPI.settings.deliverly_price)) \(ServerAPI.settings.symbol)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.theme)
                            Text("\(self.time) мин")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
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
                        .disabled(ServerAPI.settings.position == "lat=0&lon=0" || self.realm.price == 0 || ServerAPI.settings.shop_id == 0 ? true : false)
                        .opacity(ServerAPI.settings.position == "lat=0&lon=0" || self.realm.price == 0 || ServerAPI.settings.shop_id == 0 ? 0.7 : 1.0)
                        .simultaneousGesture(TapGesture().onEnded{
                            open_offer = true
                            if (ServerAPI.settings.position == "lat=0&lon=0" ){
                                ShowAlert(title: "Адрес", message: "Пожалуйста, выберите адрес для продложения оформления.")
                            }
                            
                            if (ServerAPI.settings.shop_id == 0){
                                ShowAlert(title: "Адрес", message: "Доставка в данном регионе не производится.")
                            }
                           
                        })
                        
                        
                        
                        
//                        Кнопка для покупки
//                        Данные о сумме заказа
                    }.padding([.trailing, .leading], 20)
                }
                .padding(.bottom, 40)
                .padding(.top, 30)
                .background(Color.white)
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
            
            
            
            ServerAPI.basket.get_basket(items: self.realm.get_ids()) { (load) in
                if (load){
                    self.time = ServerAPI.settings.deliverly_time
                    self.price = ServerAPI.settings.deliverly_price
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
