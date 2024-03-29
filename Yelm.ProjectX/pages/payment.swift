//
//  payment.swift
//  Yelm.ProjectX
//
//  Created by Michael on 24.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Yelm_Pay
import Combine

struct Payment: View {
    

    @ObservedObject var payment: payment = GlobalPayment
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var item: items = GlobalItems
    @State var nav_bar_hide: Bool = true
    
    

    
    @State var card: String = ""
    @State var date: String = ""
    @State var cvv: String = ""
    @State var open : Bool = false
    
    
    @State var save : Bool = true
    @State var data : Data = Data()
    @State var response_main : HTTPURLResponse = HTTPURLResponse()

    @State var count : Int = 0
    @State var bonus : Float = 0
    @Environment(\.presentationMode) var presentation
    

    
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
                            
                            Text("Оплата")
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
                
                
                
                
                VStack(spacing: 0){
                    
                    
                    
                    PaymentHeader()
                    
                    
                    VStack(spacing: 0){
                        TextField("Номер карты", text: $card)
                            .padding(5)
                            .foregroundColor(Color.init(hex: "828282"))
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 2)

                    Text("")
                    
                    HStack(spacing: 25){
                        
                        VStack(spacing: 0){
                            TextField("MM/YY", text: $date)
                                .padding(5)
                                .foregroundColor(Color.init(hex: "828282"))
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onReceive(Just(date)) { (count_new) in
                                    if (count < count_new.count){
                                        if (count_new.count == 2){
                                            self.date += "/"
                                        }
                                        
                                        count = count_new.count
                                    }else{
                                        count = count_new.count
                                    }
                                }
                            
                            Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        }
                        
                        
                        VStack(spacing: 0){
                            SecureField("CVV", text: $cvv)
                                .padding(5)
                                .foregroundColor(Color.init(hex: "828282"))
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 2)
                    
                    HStack{
                        Button(action: {
                     
                            self.save.toggle()
                            
                        }){
                            
                            Image(systemName: self.save == true ? "checkmark.square.fill" : "square")
                                .font(.system(size: 20))
                                .foregroundColor(self.save == true ? .theme : .theme)
                            
                            Text("Запомнить карту")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.init(hex: "828282"))
                                
                            
                        }
                        
                        Spacer()
                      
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 15)
                        
                        
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .clipShape(CustomShape(corner: .allCorners, radii: 20))
                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                .padding([.trailing, .leading], 20)
                
              
                
                VStack(spacing: 15){
                    Text("\(String(format:"%.2f", self.realm.get_price_full()-bonus)) \(ServerAPI.settings.symbol)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        
                        
                        
                        UserDefaults.standard.set(self.card, forKey: "card")
                        UserDefaults.standard.set(self.date, forKey: "date")

                        YelmPay.start(platform: platform, user: ServerAPI.user.username) { (load) in
                            YelmPay.core.payment(card_number: self.card,
                                                 date: self.date,
                                                 cvv: self.cvv,
                                                 merchant: ServerAPI.settings.public_id,
                                                 price: self.realm.get_price_full()-bonus,
                                                 currency: ServerAPI.settings.currency) { (load, response, data)  in
                                if (load){
                                    self.response_main = response
                                    self.data = data

                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.open.toggle()
                                    }
                                  
                                    
                                }
                            }
                        }

                    }) {
                        
                        HStack{
                            Text("Оплатить")
                                .font(.system(size: 22))
                                .padding(.horizontal, 60)
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                         


                    }

                    .frame(height: 50)
                    .buttonStyle(ScaleButtonStyle())
                    .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    .sheet(isPresented: $open) {
                        D3DS(response_main: self.$response_main, data: self.$data, open: self.$open)
                        .onDisappear{
                            if (self.payment.payment_done){
                                self.presentation.wrappedValue.dismiss()
                            }
                            
                            if (!self.payment.payment_done){
                                ShowAlert(title: "Упс...", message: self.payment.message)
                            }
                        }
                    }
                    
                    
                    Text("Нажимая кнопку «Оплатить», Вы соглашаетесь с офертой")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.init(hex: "828282"))
                        .multilineTextAlignment(.center)
                    
                }.padding()
                
                
                
                Spacer()
                

                Text("")
                    .padding()
                
                
                
                
            }
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
      
    
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        
        .onAppear {
            
            self.card = UserDefaults.standard.string(forKey: "card") ?? ""
            self.date = UserDefaults.standard.string(forKey: "date") ?? ""
            
            self.nav_bar_hide = true
            self.bottom.hide = true
           
       }
       
     
        .onDisappear{
            open_offer = false
        }
       

    }
}


struct PaymentHeader: View {
    var body: some View {
        HStack{
            
            Image("master")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 20)
            
            Image("visa")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.trailing, 6)
            
            Image("mir")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 20)
                .padding(.trailing, 5)
            
            Spacer()
        }
    }
}


struct Line: Shape {

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}
