//
//  offer.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Yelm_Pay
import UIKit

@available(iOS 13.0, *)
var osTheme: UIUserInterfaceStyle {
    return UIScreen.main.traitCollection.userInterfaceStyle
}

struct Offer: View {
    
    
    
    
    private var paymentContextDelegate = PaymentContextDelegate()
    
    
    @ObservedObject var location : location_cache = GlobalLocation
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var item: items = GlobalItems
    @State var nav_bar_hide: Bool = true
    @ObservedObject var cutlery: cutlery = GlobalCutlery

    @ObservedObject var payment: payment = GlobalPayment
    @ObservedObject var user : user_auth = GlobalUserAuth

    
    @Environment(\.presentationMode) var presentation
    
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = Color.theme.uiColor()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Color.theme_foreground.uiColor()], for: .selected)
        if (osTheme == .dark){
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }else{
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        }
    }
    
    @State var pickerSelection = 0
    
    @State var isNavigationBarHidden: Bool = true
    
    
    @State var selection: Int? = nil
    
    
    @ObservedObject var offer: offer = GlobalOffer
    @State var promocode_string: String = ""
    @State var entrance: String = ""
    @State var floor: String = ""
    @State var apartment: String = ""
    @State var phone: String = ""
    
    
    @State private var balance_bonus: Double = 0
    
    @ObservedObject var promocode : promocode = GlobalPromocode
    
    
    @ObservedObject var realm: RealmControl = GlobalRealm
    

    
    private class PaymentContextDelegate: NSObject, APDelegate {
        
        @ObservedObject var location : location_cache = GlobalLocation
        @ObservedObject var realm: RealmControl = GlobalRealm
        @ObservedObject var offer: offer = GlobalOffer
        @ObservedObject var payment: payment = GlobalPayment
        @ObservedObject var promocode : promocode = GlobalPromocode
        @ObservedObject var bottom: bottom = GlobalBottom
        @ObservedObject var cutlery: cutlery = GlobalCutlery

//        @Environment(\.presenter) var presenter

        func PaymentDone(result: Bool) {
            if (result){
                print("PaymentContextDelegate.result.done")
                
                
                let type_promocode_load = UserDefaults.standard.string(forKey: "promocode_type") ?? ""
                if (type_promocode_load != ""){
                    
                    
                    if (type_promocode_load == "full"){
                        
                        self.promocode.active = promocode_structure(id: 0, type: .full, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                    if (type_promocode_load == "delivery"){
                        self.promocode.active = promocode_structure(id: 0, type: .delivery, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                    if (type_promocode_load == "percent"){
                        self.promocode.active = promocode_structure(id: 0, type: .percent, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                }
                
                logPurchase(price: Double(self.realm.start_price),
                            currency: ServerAPI.settings.currency,
                            parameters: ["phone" : self.offer.phone,
                                         "address" : self.location.name,
                                         "total" : self.realm.price,
                                         "payment" : "card",
                                         "start_price" : self.realm.start_price])
                
                let order_detail = OrdersDetail()
                order_detail.phone = self.offer.phone
                order_detail.floor = self.offer.floor
                order_detail.address = self.location.name
                order_detail.comment = ""
                order_detail.entrance = self.offer.entrance
                order_detail.flat = self.offer.apartment
                order_detail.items = self.realm.get_ids()
                order_detail.total = self.realm.price
                order_detail.start_price = self.realm.start_price
                order_detail.delivery_price = ServerAPI.settings.deliverly_price
                order_detail.currency_value = ServerAPI.settings.currency
                order_detail.shop_id = ServerAPI.settings.shop_id
                order_detail.payment = "applepay"
                order_detail.transaction_id = YelmPay.last_transaction_id
                order_detail.discount = Float(self.promocode.active.value)
                order_detail.discount_type = type_promocode_load
                order_detail.cutlery = self.cutlery.count
                order_detail.total_bonus = Int(self.offer.bonus)
                
                ServerAPI.orders.set_order(order: order_detail) { (load) in
                    if (load){
                        print("order did send")
                        
                        self.realm.clear_cart(order: true)
                        self.payment.payment_done = true
                        
                        
                        UserDefaults.standard.removeObject(forKey:"promocode_value")
                        UserDefaults.standard.removeObject(forKey:"promocode_type")
                        
                      
                        self.promocode.active = promocode_structure(id: 0, type: .nonactive, value: 0)
                        

                        open_offer = false
                        
                        self.bottom.objectWillChange.send()
                        self.bottom.hide = false
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            windows?.rootViewController =  UIHostingController(rootView: Start())
                        }
                        
                        
                        
                    }
                }
                
                
            }
            
            if (!result){
                print("PaymentContextDelegate.result.fail")
                ShowAlert(title: "Упс...", message: "Ошибка")
            }
        }
        
    }
    
    
    var body: some View {
        
        
        
        
        ZStack(alignment: .bottom){
            VStack{
                
                
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
                        
                        Text("Оформление")
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
                
                
                ScrollView(showsIndicators: false) {
                    
                    
                        VStack{
                            HStack(){
                                Text("Промокод")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                
                                Spacer()
                            }.padding(.bottom , 5)
                            
                            
                            HStack(){
                                Text("Нажмите на магическую кнопку, чтобы промокод применился.")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.init(hex: "828282"))
                                
                                
                                Spacer()
                            }.padding(.bottom , 8)
                            
                            TextField("Промокод", text: $promocode_string)
                                .padding(.vertical, 10)
                                .autocapitalization(UITextAutocapitalizationType.none)
                                .foregroundColor(Color.init(hex: "BDBDBD"))
                                .padding(.leading, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray6), lineWidth: 2)
                                        .opacity(0.6)
                                        .overlay(
                                            HStack{
                                                Spacer()
                                                
                                                
                                                Button(action: {
                                                    
                                                    self.balance_bonus = 0
                                                    
                                                    ServerAPI.promocode.get(promo: self.promocode_string, user: ServerAPI.user.username) { (load, message, promocode_data) in
                                                        if (load){
                                                            self.promocode.active = promocode_data
                                                            ShowAlert(title: "Сообщение", message: message)
                                                            
                                                            UserDefaults.standard.set(promocode_data.value, forKey: "promocode_value")
                                                            
                                                            if (promocode_data.type == .delivery){
                                                                UserDefaults.standard.set("delivery", forKey: "promocode_type")
                                                            }
                                                            
                                                            if (promocode_data.type == .full){
                                                                UserDefaults.standard.set("full", forKey: "promocode_type")
                                                            }
                                                            
                                                            if (promocode_data.type == .percent){
                                                                UserDefaults.standard.set("percent", forKey: "promocode_type")
                                                            }
                                                           
                                                        }
                                                    }
//
                                                    
                                                    
                                                    
                                                }) {
                                                    
                                                    Rectangle()
                                                        .fill(Color.theme)
                                                        .frame(width: 50)
                                                        .clipShape(CustomShape(corner: [.topRight, .bottomRight], radii: 8))
                                                        .overlay(
                                                            Image(systemName: "wand.and.rays")
                                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                .foregroundColor(.theme_foreground)
                                                        )
                                                    
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                
                                                
                                            }
                                        )
                                )
                                .padding(.horizontal, 1)
                                .padding(.bottom , 8)
                        }
                    
                    
                    HStack(){
                        Text("Адрес")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Spacer()
                    }.padding(.bottom , 5)
                    
                    HStack(){
                        Text(self.location.name)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.init(hex: "828282"))
                        
                        
                        Spacer()
                    }.padding(.bottom , 5)
                    
                    
                    HStack(spacing: 10){
                        
                        
                        TextField("Подъезд", text: $entrance)
                            .padding(.vertical, 10)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(self.entrance.count == 0 ? Color.pink : Color.green, lineWidth: 2)
                                    .opacity(0.3)
                            )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                        
                        
                        TextField("Этаж", text: $floor)
                            .padding(.vertical, 10)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(self.floor.count == 0 ? Color.pink : Color.green, lineWidth: 2)
                                    .opacity(0.3)
                            )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                        
                        
                        TextField("Квартира", text: $apartment)
                            .padding(.vertical, 10)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(self.apartment.count == 0 ? Color.pink : Color.green, lineWidth: 2)
                                    .opacity(0.3)
                            )
                            .padding(.horizontal, 1)
                            .padding(.bottom , 8)
                    }
                    
                    
                    HStack(){
                        Text("Номер телефона")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Spacer()
                    }.padding(.bottom , 8)
                    
                    TextField("Номер телефона", text: $phone)
                        .padding(.vertical, 10)
                        .keyboardType(.numberPad)
                        .foregroundColor(Color.init(hex: "BDBDBD"))
                        .padding(.horizontal, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.phone.count < 10 ? Color.pink : Color.green, lineWidth: 2)
                                .opacity(0.3)
                        )
                        .padding(.horizontal, 1)
                        .padding(.bottom , 8)
                    
                    
                    
                    
                    
                    VStack{
                        HStack(){
                            Text("Ваш заказ")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                            Spacer()
                        }.padding(.bottom , 8)
                        
                        
                        HStack(){
                            Text("Товары")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.init(hex: "828282"))
                            
                            Spacer()
                            
                            Text("\(String(format:"%.2f", self.realm.price)) \(ServerAPI.settings.symbol)")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.theme)
                        }.padding(.bottom , 5)
                        
                        
                        if (self.promocode.active.type != .nonactive){
                            
                            if (self.promocode.active.type == .full){
                                
                                HStack(){
                                    Text("Скидка")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.init(hex: "828282"))
                                    
                                    Spacer()
                                    
                                    Text("-\(self.promocode.active.value) \(ServerAPI.settings.symbol)")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.red)
                                }.padding(.bottom , 8)
                            }
                            
                            if (self.promocode.active.type == .percent){
                                
                                HStack(){
                                    Text("Скидка")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.init(hex: "828282"))
                                    
                                    Spacer()
                                    
                                    Text("-\(self.promocode.active.value)%")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.red)
                                }.padding(.bottom , 8)
                                
                            }
                            
                            if (self.promocode.active.type == .delivery){
                                
                                HStack(){
                                    VStack(alignment: .leading, spacing: 2){
                                        Text("Скидка")
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.init(hex: "828282"))
                                        
                                        Text("На доставку")
                                            .font(.system(size: 14, weight: .regular, design: .rounded))
                                            .foregroundColor(Color.init(hex: "828282"))
                                    }
                                    
                                    Spacer()
                                    
                                    Text("-\(self.promocode.active.value)%")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color.red)
                                }.padding(.bottom , 8)
                                
                            }
                        }
                        
                        HStack(){
                            Text("Доставка")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.init(hex: "828282"))
                            
                            Spacer()
                            
                            Text("\(String(format:"%.2f", self.realm.get_price_delivery())) \(ServerAPI.settings.symbol)")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color.theme)
                        }.padding(.bottom , 8)
                    }
                    
                    
                    VStack(){
                        
                        HStack(){
                            Text("Способ оплаты")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                            Spacer()
                        }.padding(.bottom , 5)
                    
                    
                  
                        Picker(selection: $pickerSelection, label: Text("")) {
                            if (ServerAPI.settings.payments_card){
                                Text("Карта")
                                    .tag(0)
                                    .foregroundColor(Color.theme_foreground)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            
                            if (ServerAPI.settings.payments_applepay){
                                Text("Apple Pay")
                                    .tag(1)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            
                            if (ServerAPI.settings.payments_placeorder){
                                Text("Оформить")
                                    .tag(2)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom , 8)
                        
                        if (Float(self.user.balance) > 0){
                            HStack(){
                                Text("Ваши бонусы: \(String(format:"%.2f", Float(self.user.balance)-Float(self.balance_bonus))) \(ServerAPI.settings.symbol)")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                
                                Spacer()
                            }.padding(.bottom , 8)
                            
                            HStack(){
                                Text("0 \(ServerAPI.settings.symbol)")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.init(hex: "828282"))
                                Spacer()
                                Slider(value: $balance_bonus, in: 0...(self.realm.get_price_full() > Float(self.user.balance) ? Double(self.user.balance) : Double(self.realm.get_price_full())) , step: 1)
                                    .accentColor(.theme)
                                Spacer()
                                Text("\(String(format:"%.2f", Float(self.realm.get_price_full() > Float(self.user.balance) ? Double(self.user.balance) : Double(self.realm.get_price_full())))) \(ServerAPI.settings.symbol)")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.init(hex: "828282"))
                            }
                        }
                    }
                    
                    Spacer(minLength: 150)
                    
                }.padding([.trailing, .leading], 20)
                
                
                
                
                
            }
            
            
            
            
            
            VStack(spacing: 0){
                HStack(spacing: 15){
                    VStack(spacing: 5){
                        Text("\(String(format:"%.2f", self.realm.get_price_full()-Float(self.balance_bonus))) \(ServerAPI.settings.symbol)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.theme)
                        Text("Итого")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                    }.frame(width: 100)
                    
                    
                    if (self.pickerSelection == 1){
                        
                        Button(action: {
                            
                            var allow : Bool = true
                            if (self.floor == ""){
                                allow = false
                            }
                            
                            if (self.phone == ""){
                                allow = false
                            }
                            
                            if (self.apartment == ""){
                                allow = false
                            }
                            
                            if (self.entrance == ""){
                                allow = false
                            }
                            
                            if (allow == false){
                                ShowAlert(title: "Данные", message: "Вы не заполнили данные, проверьте обязательные поля, пожалуйста.")
                            }
                            
                            if(allow){
                                
                                
                                UserDefaults.standard.set(self.entrance, forKey: "entrance")
                                UserDefaults.standard.set(self.apartment, forKey: "apartment")
                                UserDefaults.standard.set(self.phone, forKey: "phone")
                                UserDefaults.standard.set(self.floor, forKey: "floor")
                                
                                YelmPay.start(platform: platform, user: ServerAPI.user.username) { (load) in

                                    self.offer.objectWillChange.send()
                                    self.offer.phone = self.phone
                                    self.offer.objectWillChange.send()
                                    self.offer.entrance = self.entrance
                                    self.offer.objectWillChange.send()
                                    self.offer.apartment = self.apartment
                                    self.offer.objectWillChange.send()
                                    self.offer.floor = self.floor
                                    self.offer.bonus = Float(self.balance_bonus)

                                    YelmPay.apple_pay.apple_pay(shop_name: name,
                                                                price: self.realm.get_price_full()-Float(self.balance_bonus),
                                                                delivery: 0,
                                                                merchant: merchant,
                                                                country: "RU",
                                                                currency: ServerAPI.settings.currency)



                                }
                            }
                            
                            
                          
                            
                            
                            
                            
                            
                            
                            
                        }) {
                            
                            HStack{
                                Spacer()
                                Text("Оплатить")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                            
                            
                            
                        }
                        
                        .frame(height: 50)
                        .buttonStyle(ApplePayButtonStyle())
                        .clipShape(CustomShape(corner: .allCorners, radii: 10))
                        .disabled(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? true : false)
                        .opacity(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? 0.7 : 1.0)
                        
                        
                    }
                    
                    if (self.pickerSelection == 0){
                        
                        NavigationLink(destination: Payment(bonus: Float(self.balance_bonus)), tag: 100, selection: $selection) {
                            
                            
                            HStack{
                                Spacer()
                                Text("Оплатить")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                            
                        }
                        .frame(height: 50)
                        .buttonStyle(ScaleButtonStyle())
                        .clipShape(CustomShape(corner: .allCorners, radii: 10))
                        .disabled(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? true : false)
                        .opacity(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? 0.7 : 1.0)
                        
                        .simultaneousGesture(TapGesture().onEnded{
                           
                            UserDefaults.standard.set(self.entrance, forKey: "entrance")
                            UserDefaults.standard.set(self.apartment, forKey: "apartment")
                            UserDefaults.standard.set(self.phone, forKey: "phone")
                            UserDefaults.standard.set(self.floor, forKey: "floor")
                            
                        })
                        
                    }
                    
                    
                    if (self.pickerSelection == 2){
                        
                        Button(action: {
                           
                            
                            
                            
                            let type_promocode_load = UserDefaults.standard.string(forKey: "promocode_type") ?? ""
                            if (type_promocode_load != ""){
                                
                                
                                if (type_promocode_load == "full"){
                                    
                                    self.promocode.active = promocode_structure(id: 0, type: .full, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                                }
                                
                                if (type_promocode_load == "delivery"){
                                    self.promocode.active = promocode_structure(id: 0, type: .delivery, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                                }
                                
                                if (type_promocode_load == "percent"){
                                    self.promocode.active = promocode_structure(id: 0, type: .percent, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                                }
                                
                            }
                            
                            
                            let order_detail = OrdersDetail()
                            order_detail.phone = self.phone
                            order_detail.floor = self.floor
                            order_detail.address = self.location.name
                            order_detail.comment = ""
                            order_detail.entrance = self.entrance
                            order_detail.flat = self.apartment
                            order_detail.items = self.realm.get_ids()
                            order_detail.total = self.realm.price
                            order_detail.start_price = self.realm.start_price
                            order_detail.delivery_price = ServerAPI.settings.deliverly_price
                            order_detail.currency_value = ServerAPI.settings.currency
                            order_detail.shop_id = ServerAPI.settings.shop_id
                            order_detail.payment = "placeorder"
                            order_detail.transaction_id = "-1"
                            order_detail.discount = Float(self.promocode.active.value)
                            order_detail.discount_type = type_promocode_load
                            order_detail.cutlery = self.cutlery.count
                            order_detail.total_bonus = Int(self.balance_bonus)
                            
                            
                            
                            ServerAPI.orders.set_order(order: order_detail) { (load) in
                                if (load){
                                    print("order did send")
                                    
                                    self.realm.clear_cart(order: true)
                                    self.payment.payment_done = true
                                    self.payment.payment_free = true
                                    
                                    UserDefaults.standard.removeObject(forKey:"promocode_value")
                                    UserDefaults.standard.removeObject(forKey:"promocode_type")
                                    
                                  
                                    self.promocode.active = promocode_structure(id: 0, type: .nonactive, value: 0)
                                    

                                    open_offer = false
                                    
                                    self.bottom.objectWillChange.send()
                                    self.bottom.hide = false
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        windows?.rootViewController =  UIHostingController(rootView: Start())
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                            
                        }) {
                            
                            
                            HStack{
                                Spacer()
                                Text("Заказать")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                            
                        }
                        .frame(height: 50)
                        .buttonStyle(ScaleButtonStyle())
                        .clipShape(CustomShape(corner: .allCorners, radii: 10))
                        .disabled(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? true : false)
                        .opacity(self.floor == "" || self.entrance == "" || self.phone.count < 10 || self.apartment == "" ? 0.7 : 1.0)
                        
                        .simultaneousGesture(TapGesture().onEnded{
                           
                            UserDefaults.standard.set(self.entrance, forKey: "entrance")
                            UserDefaults.standard.set(self.apartment, forKey: "apartment")
                            UserDefaults.standard.set(self.phone, forKey: "phone")
                            UserDefaults.standard.set(self.floor, forKey: "floor")
                            
                        })
                        
                    }
                    
                    
                    
                    //                        Кнопка для покупки
                    //                        Данные о сумме заказа
                }.padding([.trailing, .leading], 20)
            }
            .padding(.bottom, 40)
            .padding(.top, 30)
            .background(Color.theme_black_change_reverse)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 20))
            //                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .dropShadow, radius: 15, x: 0, y: 2)
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
        
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        
        .onAppear {
            
            
            
            self.nav_bar_hide = true
            self.bottom.hide = true
            
            YelmPay.apple_pay.delegate = self.paymentContextDelegate
            
            
            var access : [Int] = []
            if (ServerAPI.settings.payments_card == true){
                access.append(0)
            }
            
            if (ServerAPI.settings.payments_applepay == true){
                access.append(1)
            }
            
            if (ServerAPI.settings.payments_placeorder == true){
                access.append(2)
            }
            
            if (access.count > 0){
                self.pickerSelection = access.first!
            }else{
                self.pickerSelection = 2
            }
            
            self.entrance = UserDefaults.standard.string(forKey: "entrance") ?? ""
            self.apartment = UserDefaults.standard.string(forKey: "apartment") ?? ""
            self.phone = UserDefaults.standard.string(forKey: "phone") ?? ""
            self.floor = UserDefaults.standard.string(forKey: "floor") ?? ""
           
            
             
            let type_promocode_load = UserDefaults.standard.string(forKey: "promocode_type") ?? ""
            if (type_promocode_load != ""){
                
                
                if (type_promocode_load == "full"){
                    
                    self.promocode.active = promocode_structure(id: 0, type: .full, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                }
                
                if (type_promocode_load == "delivery"){
                    self.promocode.active = promocode_structure(id: 0, type: .delivery, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                }
                
                if (type_promocode_load == "percent"){
                    self.promocode.active = promocode_structure(id: 0, type: .percent, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                }
                
            }
            
            if (!self.payment.payment_done){
                logInitiateCheckoutEvent(contentData: "",
                                         contentId: ServerAPI.user.username,
                                         contentType: "checkout",
                                         numItems: self.realm.get_ids().count,
                                         paymentInfoAvailable: false,
                                         currency: ServerAPI.settings.currency,
                                         totalPrice: Double(self.realm.start_price))
            }
            
            if (self.payment.payment_done){
                
                logPurchase(price: Double(self.realm.start_price),
                            currency: ServerAPI.settings.currency,
                            parameters: ["phone" : self.phone,
                                         "address" : self.location.name,
                                         "total" : self.realm.price,
                                         "payment" : "card",
                                         "start_price" : self.realm.start_price])
                
                let type_promocode_load = UserDefaults.standard.string(forKey: "promocode_type") ?? ""
                if (type_promocode_load != ""){
                    
                    
                    if (type_promocode_load == "full"){
                        
                        self.promocode.active = promocode_structure(id: 0, type: .full, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                    if (type_promocode_load == "delivery"){
                        self.promocode.active = promocode_structure(id: 0, type: .delivery, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                    if (type_promocode_load == "percent"){
                        self.promocode.active = promocode_structure(id: 0, type: .percent, value: UserDefaults.standard.integer(forKey: "promocode_value"))
                    }
                    
                }
                
                let order_detail = OrdersDetail()
                order_detail.phone = self.phone
                order_detail.floor = self.floor
                order_detail.address = self.location.name
                order_detail.comment = ""
                order_detail.entrance = self.entrance
                order_detail.flat = self.apartment
                order_detail.items = self.realm.get_ids()
                order_detail.total = self.realm.price
                order_detail.start_price = self.realm.start_price
                order_detail.delivery_price = ServerAPI.settings.deliverly_price
                order_detail.currency_value = ServerAPI.settings.currency
                order_detail.shop_id = ServerAPI.settings.shop_id
                order_detail.payment = "card"
                order_detail.transaction_id = YelmPay.last_transaction_id
                order_detail.discount = Float(self.promocode.active.value)
                order_detail.discount_type = type_promocode_load
                order_detail.cutlery = self.cutlery.count
                order_detail.total_bonus = Int(self.balance_bonus)

              
                
                ServerAPI.orders.set_order(order: order_detail) { (load) in
                    if (load){
                        
                        self.promocode.active = promocode_structure(id: 0, type: .nonactive, value: 0)
                        self.realm.clear_cart(order: true)
                        
                        UserDefaults.standard.removeObject(forKey:"promocode_value")
                        UserDefaults.standard.removeObject(forKey:"promocode_type")
                        
                        open_offer = false
                        
                        self.bottom.objectWillChange.send()
                        self.bottom.hide = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            windows?.rootViewController =  UIHostingController(rootView: Start())
                        }
                        
                    }
                }
                
                
            }
            
            
        }
        
        
        .onDisappear{
            open_offer = false
        }
        
        
    }
}

